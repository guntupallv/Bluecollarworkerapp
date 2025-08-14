import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('workers').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(AppLocalizations.of(context)!.noProfileDataFound));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final idImageUrl = data['idProofUrl'];
          final verificationStatus = ((data['verificationStatus'] ?? 'NOT_VERIFIED') as String).toUpperCase();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(AppLocalizations.of(context)!.profileInformation, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('${AppLocalizations.of(context)!.name}: ${data['name'] ?? AppLocalizations.of(context)!.noTitle}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.skills}: ${(data['skills'] as List).join(', ')}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.experience}: ${data['experience'] ?? '0'} ${AppLocalizations.of(context)!.years}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.rateType}: ${data['rateType'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.expectedRate}: ${data['expectedRate'] ?? AppLocalizations.of(context)!.notMentioned}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.mobileNumber}: ${data['mobile'] ?? 'xxx'}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.address}: ${data['address'] ?? AppLocalizations.of(context)!.noAddress}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.availableNow}: ${data['availability']['availableNow'] == true ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.idVerification, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('${AppLocalizations.of(context)!.status}: $verificationStatus'),
                    const SizedBox(width: 8),
                    if (verificationStatus == 'VERIFIED')
                      const Icon(Icons.verified, color: Colors.green)
                    else
                      const Icon(Icons.verified_outlined, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),
                if (idImageUrl != null && idImageUrl.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(idImageUrl),
                              TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close)),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(image: NetworkImage(idImageUrl), fit: BoxFit.cover),
                      ),
                    ),
                  )
                else
                  Text(AppLocalizations.of(context)!.noIdProofUploaded),
              ],
            ),
          );
        },
      ),
    );
  }
}
