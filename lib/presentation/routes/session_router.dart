import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/worker/worker_dashboard.dart';
import '../screens/employer/employer_dashboard.dart';
import '../screens/auth/phone_login_screen.dart';
import '../screens/auth/role_selections_screen.dart';

class SessionRouter extends StatelessWidget {
  const SessionRouter({super.key});

  Future<Widget> _resolveInitialScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User not logged in → Go to login
      return const PhoneLoginScreen();
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!userDoc.exists || userDoc.data()?['role'] == null) {
      // First time login → Role not yet set
      return const RoleSelectionScreen();
    }

    final role = userDoc.data()?['role'];

    if (role == 'worker') {
      return const WorkerDashboard();
    } else if (role == 'employer') {
      return const EmployerDashboard();
    } else {
      // Invalid role fallback
      return const PhoneLoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _resolveInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return snapshot.data!;
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
