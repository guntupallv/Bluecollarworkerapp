import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerProfileSetupScreen extends StatefulWidget {
  const EmployerProfileSetupScreen({super.key});

  @override
  State<EmployerProfileSetupScreen> createState() => _EmployerProfileSetupScreenState();
}

class _EmployerProfileSetupScreenState extends State<EmployerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _companyNameController = TextEditingController();

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');
  String _mobileNumber = '';
  bool _isSaving = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;

      await FirebaseFirestore.instance.collection('employers').doc(uid).set({
        'userId': uid,
        'name': _nameController.text.trim(),
        'businessType': _businessTypeController.text.trim(),
        'companyName': _companyNameController.text.trim(),
        'mobile': _mobileNumber,
        'ratings': {},
        'postedJobs': 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.employerProfileSaved)),
      );

      // Navigate to employer dashboard
      GoRouter.of(context).go('/employer');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorSavingEmployerProfile(e.toString()))),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.setupEmployerProfile)),
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
                controller: _businessTypeController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.businessType),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.companyNameOptional),
              ),
              SizedBox(height: 10,),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _mobileNumber = number.phoneNumber ?? '';
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                ),
                initialValue: _phoneNumber,
                formatInput: true,
                keyboardType: TextInputType.phone,
                inputDecoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.mobileNumber,
                ),
                validator: (val) => (val == null || val.isEmpty) ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.saveProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
