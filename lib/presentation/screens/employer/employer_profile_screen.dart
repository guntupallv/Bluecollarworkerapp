import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('employers').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(AppLocalizations.of(context)!.noProfileDataFound));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text('${AppLocalizations.of(context)!.name}: ${data['name'] ?? ''}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.businessType}: ${data['businessType'] ?? ''}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.company}: ${data['companyName'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.mobileNumber}: ${data['mobile'] ?? 'xxx'}'),
                // const SizedBox(height: 8),
                // Text('Posted Jobs: ${data['postedJobs'] ?? 0}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
