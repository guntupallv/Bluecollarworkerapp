import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class WorkerNotificationsScreen extends StatefulWidget {
  const WorkerNotificationsScreen({super.key});

  @override
  State<WorkerNotificationsScreen> createState() => _WorkerNotificationsScreenState();
}

class _WorkerNotificationsScreenState extends State<WorkerNotificationsScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late Future<List<Map<String, dynamic>>> _futureNotifications;

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // in km
  }

  Future<List<Map<String, dynamic>>> _fetchNearbyJobs() async {
    final userLocation = await Geolocator.getCurrentPosition();
    final userDoc = await FirebaseFirestore.instance.collection('workers').doc(userId).get();
    final seenJobIds = Set<String>();

    final seenSnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userId)
        .collection('seenJobs')
        .get();

    for (var doc in seenSnapshot.docs) {
      seenJobIds.add(doc.id);
    }

    final jobsSnapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('postedAt', descending: true)
        .get();

    final unseenJobs = <Map<String, dynamic>>[];

    for (var doc in jobsSnapshot.docs) {
      if (seenJobIds.contains(doc.id)) continue;

      final job = doc.data();
      final lat = job['latitude'];
      final lon = job['longitude'];
      if (lat == null || lon == null) continue;

      final distance = calculateDistance(userLocation.latitude, userLocation.longitude, lat, lon);
      if (distance <= 30) {
        job['id'] = doc.id;
        job['distance'] = distance;
        unseenJobs.add(job);
      }
    }

    return unseenJobs;
  }

  Future<void> _markAsSeen(String jobId) async {
    await FirebaseFirestore.instance
        .collection('workers')
        .doc(userId)
        .collection('seenJobs')
        .doc(jobId)
        .set({'seenAt': Timestamp.now()});
  }

  @override
  void initState() {
    super.initState();
    _futureNotifications = _fetchNearbyJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noNewJobsInArea));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(job['title'] ?? 'No Title'),
                  subtitle: Text('${job['location'] ?? ''} • ${job['rate']} ${job['rateType']}'),
                  trailing: IconButton(
                    tooltip: AppLocalizations.of(context)!.markAsSeen,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green,),
                    onPressed: () async {
                      await _markAsSeen(job['id']);
                      setState(() {
                        _futureNotifications = _fetchNearbyJobs(); // refresh
                      });
                    },
                  ),
                  onTap: () {
                    GoRouter.of(context).push('/job-details', extra: {
                      'jobId': job['id'],
                      'jobData': job,
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
