import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localjobfinder/presentation/screens/employer/employer_favorite_workers_screen.dart';
import 'package:localjobfinder/presentation/screens/employer/employer_profile_screen.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({super.key});

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  int _selectedIndex = 0;

  void _confirmLogout(BuildContext context) {
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

  Widget _buildJobPostsTab() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppLocalizations.of(context)!.yourJobPosts,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .where('employerId', isEqualTo: uid)
                .orderBy('postedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text(AppLocalizations.of(context)!.noJobPostsYet));
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final postedDate = (data['postedAt'] as Timestamp?)?.toDate();
                  final formattedDate = postedDate != null
                      ? '${DateTime.now().difference(postedDate).inDays} days ago'
                      : 'Unknown';

                  return Card(
                    color: const Color(0xFFF5F3FF),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(data['title'] ?? AppLocalizations.of(context)!.untitled),
                      subtitle: Text(AppLocalizations.of(context)!.posted(formattedDate)),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        final jobId = doc.id;
                        GoRouter.of(context).push('/employer-job/$jobId');
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildJobPostsTab(),
      EmployerFavoriteWorkersScreen(),
      const EmployerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? AppLocalizations.of(context)!.employerDashboard
              : _selectedIndex == 1
              ? AppLocalizations.of(context)!.favoriteWorkers
              : AppLocalizations.of(context)!.employerProfile,
        ),
        actions: [
          if (_selectedIndex == 0) ...[
            // IconButton(
            //   icon: const Icon(Icons.add),
            //   tooltip: 'Post Job',
            //   onPressed: () => GoRouter.of(context).push('/employer-post-job'),
            // ),
            IconButton(
              icon: const Icon(Icons.location_history_rounded),
              tooltip: AppLocalizations.of(context)!.nearbyWorkers,
              onPressed: () => GoRouter.of(context).push('/employer-nearby-workers'),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: AppLocalizations.of(context)!.editProfile,
              onPressed: () => GoRouter.of(context).push('/employer-profile-setup'),
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
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.work), label: AppLocalizations.of(context)!.jobs),
          BottomNavigationBarItem(icon: const Icon(Icons.star), label: AppLocalizations.of(context)!.favoriteWorkers),
          BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: AppLocalizations.of(context)!.profile),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.postJob),
        onPressed: () => GoRouter.of(context).push('/employer-post-job'),
      )
          : null,
    );
  }
}
