import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class WorkerApplicationsScreen extends StatelessWidget {
  const WorkerApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.myApplications)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('workerId', isEqualTo: userId)
            .orderBy('appliedAt', descending: true)
            .snapshots(),
        builder: (context, appSnapshot) {
          if (appSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!appSnapshot.hasData || appSnapshot.data!.docs.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noApplicationsFound));
          }

          final applications = appSnapshot.data!.docs;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index].data() as Map<String, dynamic>;
              final jobId = app['jobId'];
              final status = app['status'] ?? 'pending';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
                builder: (context, jobSnapshot) {
                  if (!jobSnapshot.hasData || !jobSnapshot.data!.exists) {
                    return ListTile(title: Text(AppLocalizations.of(context)!.loadingJob));
                  }

                  final job = jobSnapshot.data!.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(job['title'] ?? 'No Title'),
                      subtitle: Text('${job['location'] ?? 'N/A'} • Status: $status'),
                      onTap: () {
                        // Show full details in a dialog
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(job['title'] ?? AppLocalizations.of(context)!.jobDetails),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("📍 ${AppLocalizations.of(context)!.location}: ${job['location'] ?? 'N/A'}"),
                                    const SizedBox(height: 8),
                                    Text("💼 ${AppLocalizations.of(context)!.category}: ${job['category'] ?? 'N/A'}"),
                                    const SizedBox(height: 8),
                                    Text("💰 ${AppLocalizations.of(context)!.rate}: ${job['rate']} (${job['rateType']})"),
                                    const SizedBox(height: 8),
                                    Text("⏰ ${AppLocalizations.of(context)!.timing}: ${job['jobTiming'] ?? AppLocalizations.of(context)!.notSpecified}"),
                                    const SizedBox(height: 8),
                                    Text("📞 ${AppLocalizations.of(context)!.contact}: ${job['contactMobile'] ?? 'N/A'}"),
                                    const SizedBox(height: 8),
                                    Text("📝 ${AppLocalizations.of(context)!.description}:"),
                                    Text(job['description'] ?? AppLocalizations.of(context)!.noDescription),
                                    const SizedBox(height: 16),
                                    Text("📌 ${AppLocalizations.of(context)!.status}: ${status.toUpperCase()}",
                                        style: TextStyle(
                                            color: status == 'accepted'
                                                ? Colors.green
                                                : (status == 'rejected'
                                                ? Colors.red
                                                : Colors.grey))),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(AppLocalizations.of(context)!.close),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
