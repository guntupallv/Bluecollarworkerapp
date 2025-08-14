import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerFavoriteWorkersScreen extends StatefulWidget {
  const EmployerFavoriteWorkersScreen({super.key});

  @override
  State<EmployerFavoriteWorkersScreen> createState() => _EmployerFavoriteWorkersScreenState();
}

class _EmployerFavoriteWorkersScreenState extends State<EmployerFavoriteWorkersScreen> {
  List<Map<String, dynamic>> _favoriteWorkers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteWorkers();
  }

  Future<void> _loadFavoriteWorkers() async {
    setState(() => _loading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _favoriteWorkers = [];
        _loading = false;
      });
      return;
    }

    try {
      final employerDoc = await FirebaseFirestore.instance.collection('employers').doc(uid).get();
      final List<String> workerIds = List<String>.from(employerDoc.data()?['preferredWorkers'] ?? []);

      if (workerIds.isEmpty) {
        setState(() {
          _favoriteWorkers = [];
          _loading = false;
        });
        return;
      }

      // Pull only favorites; simple client-side filter for now
      final workersSnapshot = await FirebaseFirestore.instance.collection('workers').get();

      final filtered = workersSnapshot.docs
          .where((doc) => workerIds.contains(doc.id))
          .map((doc) {
        final data = doc.data();
        // keep id handy if you need it later
        return {
          ...data,
          '_id': doc.id,
        };
      })
          .toList();

      setState(() {
        _favoriteWorkers = filtered;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString()))));
      }
    }
  }

  Future<void> _safeCall(String? rawPhone) async {
    final phone = rawPhone?.toString().replaceAll(' ', '');
    if (phone == null || phone.isEmpty) return;

    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.unableToOpenDialer)));
      }
    }
  }

  void _showWorkerDetails(Map<String, dynamic> data) {
    final verified = (data['verificationStatus']?.toString().toLowerCase() ?? 'not_verified') == 'verified';
    final idUrl = data['idProofUrl']?.toString();

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
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        verified ? Icons.verified : Icons.verified_outlined,
                        size: 16,
                        color: verified ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(width: 6),
                      Text(verified ? AppLocalizations.of(context)!.verified : AppLocalizations.of(context)!.notVerified),
                    ],
                  ),
                  backgroundColor: verified ? Colors.blue : Colors.grey.shade300,
                  labelStyle: TextStyle(color: verified ? Colors.white : Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Contact row
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 6),
                Expanded(child: Text(data['mobile'] ?? 'N/A')),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () => _safeCall(data['mobile']),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.home, size: 20),
                const SizedBox(width: 6),
                Expanded(child: Text(data['address'] ?? AppLocalizations.of(context)!.noAddressAvailable)),
              ],
            ),

            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.skillsLabel((data['skills'] is List) ? (data['skills'] as List).join(", ") : (data['skills']?.toString() ?? "N/A"))),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.experienceLabel(data['experience'] ?? 0)),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.rateTypeLabel(data['rateType'] ?? 'N/A')),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.expectedRateLabel(data['expectedRate']?.toString() ?? 'N/A')),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.availableNowLabel(data['availability']?['availableNow'] == true ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no)),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // ID Proof preview
            Text(AppLocalizations.of(context)!.idProof, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (idUrl != null && idUrl.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 4,
                                child: Image.network(idUrl),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(AppLocalizations.of(context)!.close),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(idUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context)!.tapImageToViewFullSize, style: const TextStyle(color: Colors.black54)),
                ],
              )
            else
              Text(AppLocalizations.of(context)!.noIdUploaded),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteWorkers.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noFavoriteWorkers))
          : ListView.builder(
        itemCount: _favoriteWorkers.length,
        itemBuilder: (context, index) {
          final data = _favoriteWorkers[index];
          final verified = (data['verificationStatus']?.toString().toLowerCase() ?? 'not_verified') == 'verified';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                children: [
                  Expanded(child: Text(data['name'] ?? AppLocalizations.of(context)!.noName)),
                  if (verified)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.verified, color: Colors.blue, size: 18),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.skillsLabel((data['skills'] is List) ? (data['skills'] as List).join(", ") : (data['skills']?.toString() ?? "N/A"))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(verified ? AppLocalizations.of(context)!.verified : AppLocalizations.of(context)!.notVerified),
                        backgroundColor: verified ? Colors.blue : Colors.grey.shade300,
                        labelStyle: TextStyle(color: verified ? Colors.white : Colors.black87),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () => _safeCall(data['mobile']),
              ),
              onTap: () => _showWorkerDetails(data),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFavoriteWorkers,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
