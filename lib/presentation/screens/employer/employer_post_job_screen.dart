import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/location_service.dart';
import '../../../services/translation_service.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerPostJobScreen extends StatefulWidget {
  const EmployerPostJobScreen({super.key});

  @override
  State<EmployerPostJobScreen> createState() => _EmployerPostJobScreenState();
}

class _EmployerPostJobScreenState extends State<EmployerPostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _rateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobileController = TextEditingController();

  List<Map<String, String>> _rateTypes = [];
  String _rateType = 'hourly';
  String? _detectedAddress;
  bool _posting = false;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTimeRange() {
    if (_startTime == null || _endTime == null) return AppLocalizations.of(context)!.notSet;
    return '${_startTime!.format(context)} – ${_endTime!.format(context)}';
  }

  Map<String, String> _bootstrapTranslations(String text) {
    // Seed translations with the same content; can be replaced later.
    return {
      'en': text,
      'te': text,
      'hi': text,
    };
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate() || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseFillAllFields)),
      );
      return;
    }

    setState(() => _posting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;
      final locationData = await LocationService.getCurrentLocationAndAddress();

      final title = _titleController.text.trim();
      final category = _categoryController.text.trim();
      final description = _descriptionController.text.trim();

      final job = {
        'title': title,
        'category': category,
        'description': description,

        // NEW: i18n maps
        'title_translations': _bootstrapTranslations(title),
        'category_translations': _bootstrapTranslations(category),
        'description_translations': _bootstrapTranslations(description),

        'rate': double.tryParse(_rateController.text.trim()) ?? 0,
        'rateType': _rateType.toLowerCase(),
        'contactMobile': _mobileController.text.trim(),
        'jobTiming': _formatTimeRange(),
        'employerId': uid,
        'location': locationData['address'],
        'latitude': locationData['latitude'],
        'longitude': locationData['longitude'],
        'postedAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('jobs').add({
        // keep flat fields for backwards-compat & search
        'title': title,
        'category': category,
        'description': description,

        // NEW: i18n maps
        'title_translations': _bootstrapTranslations(title),
        'category_translations': _bootstrapTranslations(category),
        'description_translations': _bootstrapTranslations(description),

        'rate': double.tryParse(_rateController.text.trim()) ?? 0,
        'rateType': _rateType.toLowerCase(),
        'contactMobile': _mobileController.text.trim(),
        'jobTiming': _formatTimeRange(),
        'employerId': uid,
        'location': locationData['address'],
        'latitude': locationData['latitude'],
        'longitude': locationData['longitude'],
        'postedAt': Timestamp.now(),
      });

      // 🔠 Translate and attach (best-effort; if it fails we still post the job)
      try {
        final translations = await TranslationService.translateJobFields(
          title: job['title'] as String,
          description: job['description'] as String,
          category: job['category'] as String,
          languages: const ['en', 'hi', 'te'],
        );
        job['translations'] = translations; // { en: {title,description,category}, hi: {...}, te: {...} }
      } catch (_) {
        // ignore – we’ll fall back to original text at read-time
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.jobPostedSuccessfully)),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _detectLocation() async {
    setState(() => _detectedAddress = null);
    try {
      final locationData = await LocationService.getCurrentLocationAndAddress();
      setState(() => _detectedAddress = locationData['address']);
    } catch (_) {
      if (!mounted) return;
      setState(() => _detectedAddress = AppLocalizations.of(context)!.locationFetchFailed);
    }
  }

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rateTypes = [
      {'label': AppLocalizations.of(context)!.perHour, 'value': 'hourly'},
      {'label': AppLocalizations.of(context)!.perDay, 'value': 'daily'},
      {'label': AppLocalizations.of(context)!.perWeek, 'value': 'weekly'},
      {'label': AppLocalizations.of(context)!.perMonth, 'value': 'monthly'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.postAJob)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobTitle),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobCategory),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.rate),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _rateType,
                items: _rateTypes
                    .map((type) => DropdownMenuItem(
                  value: type['value'],
                  child: Text(type['label']!),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _rateType = value!),
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.rateType),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.contactMobileNumber),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.jobTiming, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text(_formatTimeRange(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _pickTime(isStart: true),
                    icon: const Icon(Icons.schedule, color: Colors.green),
                    tooltip: AppLocalizations.of(context)!.startTime,
                  ),
                  IconButton(
                    onPressed: () => _pickTime(isStart: false),
                    icon: const Icon(Icons.schedule, color: Colors.red),
                    tooltip: AppLocalizations.of(context)!.endTime,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobDescription),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _detectedAddress ?? AppLocalizations.of(context)!.fetchingCurrentLocation,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _posting ? null : _postJob,
                child: _posting ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.postJob),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
