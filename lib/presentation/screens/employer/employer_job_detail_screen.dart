import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerJobDetailScreen extends StatelessWidget {
  final String jobId;

  const EmployerJobDetailScreen({super.key, required this.jobId});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteJob),
        content: Text(AppLocalizations.of(context)!.deleteJobConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to dashboard
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.jobDeleted)),
              );
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.jobDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: AppLocalizations.of(context)!.edit,
            onPressed: () {
              GoRouter.of(context).push('/employer-edit-job/$jobId');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: AppLocalizations.of(context)!.delete,
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(AppLocalizations.of(context)!.jobNotFound));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text('${AppLocalizations.of(context)!.title}: ${data['title'] ?? ''}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('${AppLocalizations.of(context)!.category}: ${data['category'] ?? ''}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.jobTimings}: ${data['jobTiming'] ?? AppLocalizations.of(context)!.noTimingsMentioned}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.location}: ${data['location'] ?? ''}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.rate}: ${data['rate'] ?? ''} (${data['rateType'] ?? AppLocalizations.of(context)!.notSpecified})'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.contactNumber}: ${data['contactMobile'] ?? 'xxx'}'),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.description}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data['description'] ?? AppLocalizations.of(context)!.noDescriptionProvided),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.postedAt((data['postedAt'] as Timestamp).toDate().toString()), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: () {
                    GoRouter.of(context).push(
                      '/employer-applicants/$jobId',
                      extra: data['title'] ?? AppLocalizations.of(context)!.untitledJob,
                    );
                  },
                  icon: const Icon(Icons.group),
                  label: Text(AppLocalizations.of(context)!.viewApplicants),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
