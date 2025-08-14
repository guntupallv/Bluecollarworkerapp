import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errUserNotLoggedIn)),
      );
      return;
    }

    final uid = user.uid;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final existingRole = doc.data()?['role'];

      if (existingRole != null && existingRole != role) {
        // localized with placeholder
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.errRoleLocked(existingRole))),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'role': role},
        SetOptions(merge: true),
      );

      if (role == 'worker') {
        GoRouter.of(context).go('/worker');
      } else {
        GoRouter.of(context).go('/employer');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errGeneric(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.selectRole)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(loc.youAreSigningInAs, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _selectRole(context, 'worker'),
              icon: const Icon(Icons.handyman),
              label: Text(loc.worker),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _selectRole(context, 'employer'),
              icon: const Icon(Icons.business_center),
              label: Text(loc.employer),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
