import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController(); // +{country}{number}
  bool _sending = false;
  String? _error;

  Future<void> _sendCode() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() { _sending = true; _error = null; });

    final phone = _phoneCtrl.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          GoRouter.of(context).go('/select-role');
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.errAutoSignInFailed(e.toString()))),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() { _sending = false; _error = e.message; });
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() => _sending = false);
        if (!mounted) return;
        GoRouter.of(context).push('/verify-otp', extra: {
          'verificationId': verificationId,
          'resendToken': forceResendingToken,
          'phone': phone,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.loginWithPhone)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: loc.labelPhoneExample,
                ),
                validator: (v) {
                  final val = (v ?? '').trim();
                  if (val.isEmpty) return loc.errPhoneRequired;
                  if (!val.startsWith('+')) return loc.errPhoneCountryCode;
                  if (val.length < 10) return loc.errPhoneInvalid;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const Spacer(),
              ElevatedButton(
                onPressed: _sending ? null : _sendCode,
                child: _sending
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(loc.sendOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
