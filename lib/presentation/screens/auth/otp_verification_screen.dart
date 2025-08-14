import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final int? resendToken;
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    this.resendToken,
    required this.phone,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _codeCtrl = TextEditingController();
  bool _verifying = false;
  String? _error;
  late String _verificationId;
  int? _resendToken;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _resendToken = widget.resendToken;
  }

  Future<void> _verify() async {
    final loc = AppLocalizations.of(context)!;
    final code = _codeCtrl.text.trim();
    if (code.length < 6) {
      setState(() => _error = loc.errOtpSixDigits);
      return;
    }

    setState(() { _verifying = true; _error = null; });
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      final userCred = await FirebaseAuth.instance.signInWithCredential(cred);
      final uid = userCred.user!.uid;
      final phone = userCred.user!.phoneNumber ?? widget.phone;

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final snapshot = await userRef.get();
      if (!snapshot.exists) {
        await userRef.set({
          'uid': uid,
          'phoneNumber': phone,
          'role': null,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }

      if (!mounted) return;
      GoRouter.of(context).go('/select-role');
    } on FirebaseAuthException catch (e) {
      setState(() { _verifying = false; _error = e.message; });
    } catch (e) {
      setState(() { _verifying = false; _error = e.toString(); });
    }
  }

  Future<void> _resend() async {
    final loc = AppLocalizations.of(context)!;
    setState(() { _error = null; });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      forceResendingToken: _resendToken,
      verificationCompleted: (cred) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(cred);
          if (!mounted) return;
          GoRouter.of(context).go('/select-role');
        } catch (_) {}
      },
      verificationFailed: (e) {
        setState(() { _error = e.message; });
      },
      codeSent: (verificationId, token) {
        setState(() {
          _verificationId = verificationId;
          _resendToken = token;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.otpResent)),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.verifyPhone(widget.phone))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: loc.enterOtp,
                counterText: '',
              ),
            ),
            const SizedBox(height: 10),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifying ? null : _verify,
              child: _verifying
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(loc.verifyAndContinue),
            ),
            TextButton(
              onPressed: _resend,
              child: Text(loc.resendOtp),
            ),
          ],
        ),
      ),
    );
  }
}
