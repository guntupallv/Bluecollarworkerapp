import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../services/location_service.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class WorkerProfileSetupScreen extends StatefulWidget {
  const WorkerProfileSetupScreen({super.key});

  @override
  State<WorkerProfileSetupScreen> createState() => _WorkerProfileSetupScreenState();
}

class _WorkerProfileSetupScreenState extends State<WorkerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _rateController = TextEditingController();

  String _rateType = 'Per Hour';
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');
  String _mobileNumber = '';
  bool _availableNow = true;
  bool _isSaving = false;
  File? _idImage;

  List<String> _rateTypes = [];

  void _initializeLocalizedOptions() {
    final loc = AppLocalizations.of(context)!;
    _rateTypes = [loc.perHour, loc.perDay, loc.perWeek, loc.perMonth];
  }

  // -------------------
  // Image picking bits
  // -------------------
  Future<void> _chooseImageSource() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () async {
                Navigator.pop(context);
                await _pickIdImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () async {
                Navigator.pop(context);
                await _pickIdImage(ImageSource.camera);
              },
            ),
            if (_idImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.removeSelected),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _idImage = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickIdImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1600, // light compression to keep uploads snappy
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _idImage = File(picked.path));
    }
  }

  Future<String?> _uploadIdProof(String uid) async {
    if (_idImage == null) return null;
    final ref = FirebaseStorage.instance.ref().child('worker_ids/$uid.jpg');
    final uploadTask = await ref.putFile(_idImage!);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;
      final locationData = await LocationService.getCurrentLocationAndAddress();

      String? idUrl;
      String verificationStatus = 'not_verified';
      if (_idImage != null) {
        idUrl = await _uploadIdProof(uid);
        verificationStatus = 'verified';
      }

      await FirebaseFirestore.instance.collection('workers').doc(uid).set({
        'userId': uid,
        'name': _nameController.text.trim(),
        'skills': _skillsController.text.trim().split(',').map((e) => e.trim()).toList(),
        'experience': int.tryParse(_experienceController.text.trim()) ?? 0,
        'rateType': _rateType,
        'expectedRate': double.tryParse(_rateController.text.trim()) ?? 0.0,
        'mobile': _mobileNumber,
        'address': locationData['address'],
        'lat': locationData['latitude'],
        'lng': locationData['longitude'],
        'availability': {'availableNow': _availableNow},
        'ratings': {},
        'verificationStatus': verificationStatus,
        if (idUrl != null) 'idProofUrl': idUrl,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileSavedSuccessfully)),
      );
      GoRouter.of(context).go('/worker');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorSavingProfile(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalizedOptions();
    });
    
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.setupWorkerProfile)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.fullName),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.skillsCommaSeparated),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.experienceYears),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _rateType,
                items: _rateTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => setState(() => _rateType = value!),
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.rateType),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.expectedRateAmount),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) => _mobileNumber = number.phoneNumber ?? '',
                selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DROPDOWN),
                initialValue: _phoneNumber,
                formatInput: true,
                keyboardType: TextInputType.phone,
                inputDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.mobileNumber),
                validator: (val) => (val == null || val.isEmpty) ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.availableNow),
                value: _availableNow,
                onChanged: (val) => setState(() => _availableNow = val),
              ),
              const SizedBox(height: 16),

              // Upload + preview
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _chooseImageSource,
                    icon: const Icon(Icons.upload_file),
                    label: Text(AppLocalizations.of(context)!.uploadIdCameraGallery),
                  ),
                  const SizedBox(width: 12),
                  if (_idImage != null)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_idImage!, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.saveProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
