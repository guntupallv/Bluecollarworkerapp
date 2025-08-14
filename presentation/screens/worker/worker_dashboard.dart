import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/presentation/screens/worker/worker_notifications_screen.dart';
import 'package:localjobfinder/presentation/screens/worker/worker_profile_screen.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:localjobfinder/l10n/app_localizations.dart';
import '../../../services/location_service.dart';
import '../../../utils/lang.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  int _selectedIndex = 0;
  int _unseenNotificationCount = 0;

  String _searchQuery = '';
  String _selectedRateType = 'any';
  String _sortBy = '';

  List<Map<String, String>> _rateTypes = [];
  List<String> _sortOptions = [];

  void _initializeLocalizedOptions() {
    final loc = AppLocalizations.of(context)!;
    _rateTypes = [
      {'label': loc.rateAny, 'value': 'any'},
      {'label': loc.ratePerHour, 'value': 'hourly'},
      {'label': loc.ratePerDay, 'value': 'daily'},
      {'label': loc.ratePerWeek, 'value': 'weekly'},
      {'label': loc.ratePerMonth, 'value': 'monthly'},
    ];

    _sortOptions = [loc.sortClosest, loc.sortHighestPay, loc.sortNewest];
    // Set the initial sort value to the localized closest option
    if (_sortBy.isEmpty) {
      _sortBy = loc.sortClosest;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        _markNotificationsAsSeen();
        _unseenNotificationCount = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalizedOptions();
    });
    _requestLocationPermission();
    _listenForNewJobs();
  }

  Future<void> _markNotificationsAsSeen() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final position = await Geolocator.getCurrentPosition();

    final snapshot = await FirebaseFirestore.instance.collection('jobs').get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final lat = data['latitude'];
      final lon = data['longitude'];
      if (lat == null || lon == null) continue;

      final distance = calculateDistance(
        position.latitude,
        position.longitude,
        lat,
        lon,
      );

      final seenBy = List<String>.from(data['seenBy'] ?? []);
      if (distance <= 30 && !seenBy.contains(userId)) {
        final ref = FirebaseFirestore.instance.collection('jobs').doc(doc.id);
        batch.update(ref, {
          'seenBy': FieldValue.arrayUnion([userId])
        });
      }
    }

    await batch.commit();
  }

  StreamSubscription? _jobSubscription;

  @override
  void dispose() {
    _jobSubscription?.cancel();
    super.dispose();
  }

  Future<void> _listenForNewJobs() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final position = await Geolocator.getCurrentPosition();

    _jobSubscription = FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('postedAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      int newJobs = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final lat = data['latitude'];
        final lon = data['longitude'];

        if (lat == null || lon == null) continue;

        final distance = calculateDistance(
          position.latitude,
          position.longitude,
          lat,
          lon,
        );

        final seenBy = List<String>.from(data['seenBy'] ?? []);
        if (distance <= 30 && !seenBy.contains(userId)) {
          newJobs++;
        }
      }

      if (mounted) {
        setState(() {
          _unseenNotificationCount = newJobs;
        });
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    try {
      await LocationService.getCurrentLocationAndAddress();
    } catch (e) {
      print('Location permission error: $e');
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.locationPermissionRequired)),
      );
    }
  }

  void _confirmLogout(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmLogout),
        content: Text(AppLocalizations.of(context)!.logoutPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              GoRouter.of(context).go('/login');
            },
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final pages = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(loc.nearbyJobs, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: loc.searchByTitleOrCategory,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(loc.rateType),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _selectedRateType,
                      items: _rateTypes.map((type) {
                        return DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedRateType = val!),
                    ),
                    const Spacer(),
                    Text(loc.sort),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _sortBy,
                      items: _sortOptions.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (val) => setState(() => _sortBy = val!),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<Position>(
              future: Geolocator.getCurrentPosition(),
              builder: (context, locationSnapshot) {
                if (!locationSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentPosition = locationSnapshot.data!;

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('jobs')
                      .orderBy('postedAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final allJobs = snapshot.data!.docs.map((doc) {
                      final data = doc.data();
                      data['id'] = doc.id;
                      return data;
                    }).toList();

                    List<Map<String, dynamic>> filteredJobs = allJobs.where((job) {
                      final title = (job['title'] ?? '').toString().toLowerCase();
                      final category = (job['category'] ?? '').toString().toLowerCase();
                      final rateType = job['rateType']?.toString().toLowerCase() ?? '';
                      final lat = job['latitude'];
                      final lon = job['longitude'];

                      if (lat == null || lon == null) return false;

                      final distance = calculateDistance(
                        currentPosition.latitude,
                        currentPosition.longitude,
                        lat,
                        lon,
                      );

                      job['distance'] = distance;

                      return (title.contains(_searchQuery) || category.contains(_searchQuery)) &&
                          (_selectedRateType == 'any' || rateType == _selectedRateType) &&
                          distance <= 30;
                    }).toList();

                    final loc = AppLocalizations.of(context)!;
                    if (_sortBy == loc.sortHighestPay) {
                      filteredJobs.sort((a, b) => (b['rate'] ?? 0).compareTo(a['rate'] ?? 0));
                    } else if (_sortBy == loc.sortNewest) {
                      filteredJobs.sort((a, b) =>
                          (b['postedAt'] as Timestamp).compareTo(a['postedAt'] as Timestamp));
                    } else {
                      filteredJobs.sort((a, b) =>
                          (a['distance'] as double).compareTo(b['distance'] as double));
                    }

                    if (filteredJobs.isEmpty) {
                      return Center(child: Text(loc.noJobsFoundMatching));
                    }

                    return ListView.builder(
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];

                        final lang = currentLang(context);
                        final Map<String, dynamic>? t = (job['translations'] as Map?)?.cast<String, dynamic>();
                        final Map<String, dynamic>? tl = (t?[lang] as Map?)?.cast<String, dynamic>();

                        final title = (tl?['title'] as String?)?.trim().isNotEmpty == true
                            ? tl!['title'] as String
                            : (job['title'] ?? 'No Title');

                        final category = (tl?['category'] as String?)?.trim().isNotEmpty == true
                            ? tl!['category'] as String
                            : (job['category'] ?? '');

                        final subtitleText = '${job['location'] ?? 'N/A'} • ${job['rateType'] ?? ''} ${job['rate'] ?? 0}';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(subtitleText),
                            trailing: const Icon(Icons.arrow_forward),
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
                );
              },
            ),
          ),
        ],
      ),
      const WorkerNotificationsScreen(),
      const WorkerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? loc.workerDashboard
              : _selectedIndex == 1
              ? loc.jobNotifications
              : loc.profile,
        ),
        actions: [
          if (_selectedIndex == 0) ...[
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: loc.editProfile,
              onPressed: () {
                GoRouter.of(context).push('/worker-profile-setup');
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: loc.jobApplications,
              onPressed: () {
                GoRouter.of(context).push('/worker-applications');
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.work), label: loc.jobs),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (_unseenNotificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unseenNotificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: loc.alerts,
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: loc.profile),
        ],
      ),
    );
  }
}
