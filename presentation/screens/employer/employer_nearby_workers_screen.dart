import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/location_service.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerNearbyWorkersScreen extends StatefulWidget {
  const EmployerNearbyWorkersScreen({super.key});

  @override
  State<EmployerNearbyWorkersScreen> createState() => _EmployerNearbyWorkersScreenState();
}

class _EmployerNearbyWorkersScreenState extends State<EmployerNearbyWorkersScreen> {
  List<QueryDocumentSnapshot> _nearbyWorkers = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  String _employerId = '';
  List<String> _preferredWorkerIds = [];

  @override
  void initState() {
    super.initState();
    _loadEmployerInfo();
  }

  Future<void> _loadEmployerInfo() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('employers').doc(userId).get();
    _employerId = userId;
    _preferredWorkerIds = List<String>.from(doc.data()?['preferredWorkers'] ?? []);
    _loadNearbyWorkers();
  }

  Future<void> _loadNearbyWorkers() async {
    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final pos = await LocationService.getCurrentLocation();
      final double lat1 = pos.latitude;
      final double lon1 = pos.longitude;

      final snapshot = await FirebaseFirestore.instance.collection('workers').get();

      final querySkills = _searchController.text
          .toLowerCase()
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final nearby = snapshot.docs.where((doc) {
        final data = doc.data();

        if (data['lat'] == null || data['lng'] == null) return false;

        // distance <= 30km
        final double lat2 = (data['lat'] as num).toDouble();
        final double lon2 = (data['lng'] as num).toDouble();
        final distance = Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000.0;
        if (distance > 30) return false;

        // skills (case-insensitive)
        if (querySkills.isEmpty) return true;
        final workerSkills = (data['skills'] as List? ?? [])
            .map((s) => s.toString().toLowerCase())
            .toList();

        return querySkills.any((skill) => workerSkills.contains(skill));
      }).toList();

      if (!mounted) return;
      setState(() {
        _nearbyWorkers = nearby;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString()))));
    }
  }

  Future<void> _toggleFavorite(String workerId) async {
    final isFav = _preferredWorkerIds.contains(workerId);
    setState(() {
      if (isFav) {
        _preferredWorkerIds.remove(workerId);
      } else {
        _preferredWorkerIds.add(workerId);
      }
    });

    await FirebaseFirestore.instance.collection('employers').doc(_employerId).update({
      'preferredWorkers': _preferredWorkerIds,
    });
  }

  void _showIdPreview(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: InteractiveViewer(
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkerDetails(Map<String, dynamic> data) {
    final idUrl = (data['idProofUrl'] ?? '').toString();
    final isVerified = (data['verificationStatus']?.toString().toLowerCase() == 'verified');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['name'] ?? AppLocalizations.of(context)!.noName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isVerified)
                  const Chip(
                    label: Text('Verified'),
                    avatar: Icon(Icons.verified, color: Colors.white, size: 18),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Text('${AppLocalizations.of(context)!.mobile}: ${data['mobile'] ?? 'N/A'}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    final phone = data['mobile']?.toString().replaceAll(' ', '');
                    if (phone != null && phone.isNotEmpty) {
                      launchUrl(Uri.parse('tel:$phone'));
                    }
                  },
                ),
              ],
            ),
            Text('${AppLocalizations.of(context)!.address}: ${data['address'] ?? 'N/A'}'),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.skillsLabel((data['skills'] as List? ?? []).join(', '))),
            Text('${AppLocalizations.of(context)!.expectedRate}: ${data['expectedRate'] ?? 'N/A'}'),
            Text('${AppLocalizations.of(context)!.rateType}: ${data['rateType'] ?? 'N/A'}'),
            Text('${AppLocalizations.of(context)!.experience}: ${data['experience'] ?? 'N/A'} ${AppLocalizations.of(context)!.years}'),
            Text('${AppLocalizations.of(context)!.availableNow}: ${data['availability']?['availableNow'] == true ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no}'),

            const SizedBox(height: 12),
            if (idUrl.isNotEmpty) ...[
              const Divider(),
              Text(AppLocalizations.of(context)!.idProof, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showIdPreview(idUrl),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(idUrl, height: 160, fit: BoxFit.cover),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.nearbyWorkers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNearbyWorkers,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchBySkills,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadNearbyWorkers();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _loadNearbyWorkers(),
            ),
          ),
          Expanded(
            child: _nearbyWorkers.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)!.noWorkersFoundNearby))
                : ListView.builder(
              itemCount: _nearbyWorkers.length,
              itemBuilder: (context, index) {
                final data = _nearbyWorkers[index].data() as Map<String, dynamic>;
                final workerId = _nearbyWorkers[index].id;
                final isFav = _preferredWorkerIds.contains(workerId);
                final isVerified = (data['verificationStatus']?.toString().toLowerCase() == 'verified');
                final idUrl = (data['idProofUrl'] ?? '').toString();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    title: Row(
                      children: [
                        Expanded(child: Text(data['name'] ?? AppLocalizations.of(context)!.noName)),
                        if (isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Chip(
                              label: Text('Verified'),
                              avatar: Icon(Icons.verified, color: Colors.white, size: 18),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(AppLocalizations.of(context)!.skillsLabel((data['skills'] as List? ?? []).join(', '))),
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        if (idUrl.isNotEmpty)
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.viewId,
                            icon: const Icon(Icons.badge_outlined),
                            onPressed: () => _showIdPreview(idUrl),
                          ),
                        IconButton(
                          tooltip: isFav ? AppLocalizations.of(context)!.unfavorite : AppLocalizations.of(context)!.favorite,
                          icon: Icon(isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.orange : Colors.grey),
                          onPressed: () => _toggleFavorite(workerId),
                        ),
                      ],
                    ),
                    onTap: () => _showWorkerDetails(data),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
