import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerApplicantsScreen extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const EmployerApplicantsScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  Future<void> _updateStatus(String applicationId, String status) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({'status': status});
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _launchDialer(BuildContext context, String mobile) async {
    final Uri uri = Uri(scheme: 'tel', path: mobile);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unableToOpenDialer)),
      );
    }
  }

  void _showFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(url, fit: BoxFit.contain),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            )
          ],
        ),
      ),
    );
  }

  void _showWorkerDetails(
      BuildContext context,
      Map<String, dynamic> worker,
      String workerId,
      ) {
    final List<dynamic> rawSkills = (worker['skills'] ?? []) as List<dynamic>;
    final skills = rawSkills.map((e) => e.toString()).toList();
    final bool availableNow =
    (worker['availability'] is Map && worker['availability']?['availableNow'] == true);
    final String verificationStatus =
    (worker['verificationStatus'] ?? 'not_verified').toString().toLowerCase();
    final String? idProofUrl = worker['idProofUrl']?.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Verified badge
                Row(
                  children: [
                    Expanded(
                      child:                     Text(
                      worker['name']?.toString() ?? AppLocalizations.of(context)!.unnamed,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ),
                    if (verificationStatus == 'verified')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(AppLocalizations.of(context)!.verified, style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.phone, size: 20),
                    const SizedBox(width: 6),
                    Text(worker['mobile']?.toString() ?? AppLocalizations.of(context)!.notProvided),
                    const Spacer(),
                    if (worker['mobile'] != null)
                      IconButton(
                        icon: const Icon(Icons.call, color: Colors.green),
                        onPressed: () => _launchDialer(context, worker['mobile'].toString()),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.home, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(worker['address']?.toString() ?? AppLocalizations.of(context)!.noAddressAvailable),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Wrap(
                  runSpacing: 8,
                  children: [
                    _kv(AppLocalizations.of(context)!.skills, skills.isEmpty ? 'N/A' : skills.join(', ')),
                    _kv(AppLocalizations.of(context)!.experience, '${worker['experience'] ?? 0} ${AppLocalizations.of(context)!.years}'),
                    _kv(AppLocalizations.of(context)!.rateType.replaceAll(':', ''), worker['rateType']?.toString() ?? 'N/A'),
                    _kv(AppLocalizations.of(context)!.expectedRate,
                        (worker['expectedRate'] != null) ? worker['expectedRate'].toString() : 'N/A'),
                    _kv(AppLocalizations.of(context)!.availableNow, availableNow ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),

                // ID Proof (if available)
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.idProof, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (idProofUrl != null && idProofUrl.isNotEmpty)
                  GestureDetector(
                    onTap: () => _showFullImage(context, idProofUrl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(idProofUrl, fit: BoxFit.cover),
                      ),
                    ),
                  )
                else
                  Text(AppLocalizations.of(context)!.noIdProofUploaded),

                const SizedBox(height: 16),
                const Divider(),
                Text(AppLocalizations.of(context)!.ratingsAndReviews, style: const TextStyle(fontWeight: FontWeight.bold)),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('workers')
                      .doc(workerId)
                      .collection('reviews')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    }

                    final reviews = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                    if (reviews.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context)!.noReviewsYet),
                      );
                    }

                    final ratings = reviews
                        .map((r) => (r['rating'] is num) ? (r['rating'] as num).toDouble() : 0.0)
                        .toList();
                    final avg = ratings.isEmpty
                        ? 0.0
                        : ratings.reduce((a, b) => a + b) / ratings.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(AppLocalizations.of(context)!.averageRating(avg.toStringAsFixed(1), reviews.length)),
                        const SizedBox(height: 8),
                        ...reviews.map((r) {
                          final rating = (r['rating'] is num) ? (r['rating'] as num).toDouble() : 0.0;
                          final comment = r['comment']?.toString() ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text('${rating.toStringAsFixed(1)}/5'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (comment.isNotEmpty)
                                  Text(comment, style: const TextStyle(color: Colors.black87)),
                                const Divider(),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showRateWorkerDialog(BuildContext context, String workerId) async {
    final ratingController = TextEditingController();
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.rateWorker),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.ratingLabel),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.comment),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final rating = double.tryParse(ratingController.text.trim());
              final comment = commentController.text.trim();
              final employerId = FirebaseAuth.instance.currentUser?.uid;

              if (rating == null || rating < 1 || rating > 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.enterValidRating)),
                );
                return;
              }

              await FirebaseFirestore.instance
                  .collection('workers')
                  .doc(workerId)
                  .collection('reviews')
                  .add({
                'rating': rating,
                'comment': comment,
                'employerId': employerId,
                'timestamp': Timestamp.now(),
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.reviewSubmitted)),
              );
            },
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.applicantsForJob(jobTitle))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('jobId', isEqualTo: jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final apps = snapshot.data?.docs ?? [];

          if (apps.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noApplicantsYet));
          }

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final appDoc = apps[index];
              final app = appDoc.data() as Map<String, dynamic>;
              final workerId = app['workerId'];
              final status = app['status'] ?? 'pending';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('workers').doc(workerId).get(),
                builder: (context, workerSnapshot) {
                  if (!workerSnapshot.hasData) {
                    return ListTile(title: Text(AppLocalizations.of(context)!.loading));
                  }
                  if (!workerSnapshot.data!.exists) {
                    return ListTile(title: Text(AppLocalizations.of(context)!.workerProfileNotFound));
                  }

                  final worker = workerSnapshot.data!.data() as Map<String, dynamic>;

                  final name = worker['name']?.toString() ?? AppLocalizations.of(context)!.unnamed;
                  final List<dynamic> rawSkills = (worker['skills'] ?? []) as List<dynamic>;
                  final skills = rawSkills.map((e) => e.toString()).join(', ');
                  final experience = worker['experience'] ?? 0;
                  final verificationStatus =
                  (worker['verificationStatus'] ?? 'not_verified').toString().toLowerCase();

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () => _showWorkerDetails(context, worker, workerId),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name + verified chip in list item as well
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (verificationStatus == 'verified')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.verified, size: 16, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text(AppLocalizations.of(context)!.verified, style: const TextStyle(color: Colors.green)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context)!.skillsLabel(skills)),
                            Text(AppLocalizations.of(context)!.experienceLabel(experience)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(status.toUpperCase()),
                                  backgroundColor: _getStatusColor(status).withOpacity(0.1),
                                  labelStyle: TextStyle(color: _getStatusColor(status)),
                                ),
                                if (status == 'pending')
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () => _updateStatus(appDoc.id, 'accepted'),
                                        child: Text(
                                          AppLocalizations.of(context)!.accept,
                                          style: const TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => _updateStatus(appDoc.id, 'rejected'),
                                        child: Text(
                                          AppLocalizations.of(context)!.reject,
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (status == 'accepted')
                                  TextButton.icon(
                                    onPressed: () => showRateWorkerDialog(context, workerId),
                                    icon: const Icon(Icons.rate_review),
                                    label: Text(AppLocalizations.of(context)!.rateWorkerButton),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  // small helper for key/value lines
  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$key: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
