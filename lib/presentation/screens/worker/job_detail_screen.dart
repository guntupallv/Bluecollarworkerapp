import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/translation_service.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class JobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobData, required this.jobId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _isApplying = false;
  bool _alreadyApplied = false;

  // in-memory cache for this screen, keyed by "<lang>.<field>"
  final Map<String, String> _tCache = {};
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyApplied();
    _prepareTranslations(); // fire and forget
  }

  Future<void> _checkIfAlreadyApplied() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('applications')
        .where('jobId', isEqualTo: widget.jobId)
        .where('workerId', isEqualTo: userId)
        .limit(1)
        .get();

    if (mounted) {
      setState(() => _alreadyApplied = snapshot.docs.isNotEmpty);
    }
  }

  // Try to ensure the current UI language is translated for title/category/description.
  Future<void> _prepareTranslations() async {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    if (lang == 'en') return; // example: skip if UI is already English

    // We'll try to fetch or translate these 3 fields
    await Future.wait([
      _fetchOrTranslateField('title'),
      _fetchOrTranslateField('category'),
      _fetchOrTranslateField('description'),
    ]);
  }

  Future<void> _fetchOrTranslateField(String baseKey) async {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    final k = '$lang.$baseKey';

    // If we already have a translation in cache or Firestore map, no need to translate again.
    final existing = _readTranslatedFromJob(widget.jobData, baseKey, lang);
    if (existing.isNotEmpty) {
      _tCache[k] = existing;
      if (mounted) setState(() {});
      return;
    }

    // Fallback original text (flat field)
    final original = (widget.jobData[baseKey] as String?)?.trim() ?? '';
    if (original.isEmpty) return;

    // Translate using your TranslationService (auto-detect source -> lang)
    try {
      setState(() => _isTranslating = true);
      final translated = await TranslationService.translate(text: original, target: lang);
      if (translated == null || translated.trim().isEmpty) return;

      _tCache[k] = translated.trim();
      if (mounted) setState(() {});

      // Write back to Firestore so future loads don’t need to translate again
      await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update({
        '${baseKey}_translations.$lang': translated.trim(),
      });
    } catch (_) {
      // swallow errors; we’ll just show the original
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  // Helper: read from the per-field translations map if present
  String _readTranslatedFromJob(Map<String, dynamic> job, String baseKey, String lang) {
    final map = job['${baseKey}_translations'];
    if (map is Map) {
      final byCode = map[lang];
      if (byCode is String && byCode.trim().isNotEmpty) return byCode;
      final en = map['en'];
      if (en is String && en.trim().isNotEmpty) return en;
    }
    return '';
  }

  // i18n getter with fallback: translations -> cache -> original
  String _i18n(String baseKey, BuildContext ctx) {
    final lang = Localizations.localeOf(ctx).languageCode.toLowerCase();

    // 1) translations map inside job
    final fromMap = _readTranslatedFromJob(widget.jobData, baseKey, lang);
    if (fromMap.isNotEmpty) return fromMap;

    // 2) in-memory cache filled by _prepareTranslations
    final cached = _tCache['$lang.$baseKey'];
    if (cached != null && cached.isNotEmpty) return cached;

    // 3) flat fallback
    final flat = widget.jobData[baseKey];
    return (flat is String && flat.isNotEmpty) ? flat : '';
  }

  Future<void> _applyForJob() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _alreadyApplied) return;

    setState(() => _isApplying = true);

    try {
      await FirebaseFirestore.instance.collection('applications').add({
        'jobId': widget.jobId,
        'workerId': userId,
        'appliedAt': Timestamp.now(),
        'status': 'pending',
      });

      if (mounted) {
        setState(() {
          _alreadyApplied = true;
          _isApplying = false;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.applicationSubmitted)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isApplying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _launchPhoneDialer(String phoneNumber) async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: phoneNumber.trim());
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.failedToLaunchDialer)),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.cannotLaunchDialer)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _rateTypeLabel(String? value) {
    final loc = AppLocalizations.of(context)!;
    switch ((value ?? '').toLowerCase()) {
      case 'hourly':
        return loc.perHour;
      case 'daily':
        return loc.perDay;
      case 'weekly':
        return loc.perWeek;
      case 'monthly':
        return loc.perMonth;
      default:
        return value ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.jobData;

    final title = _i18n('title', context);
    final category = _i18n('category', context);
    final description = _i18n('description', context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.jobDetails)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_isTranslating) const SizedBox(width: 8),
                if (_isTranslating)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            Text("${AppLocalizations.of(context)!.category}: ${category.isEmpty ? 'N/A' : category}"),
            const SizedBox(height: 8),

            Text("${AppLocalizations.of(context)!.rate}: ${job['rate']} ${_rateTypeLabel(job['rateType'])}"),
            const SizedBox(height: 8),

            Text("${AppLocalizations.of(context)!.location}: ${job['location'] ?? 'N/A'}"),
            const SizedBox(height: 8),

            Text("${AppLocalizations.of(context)!.timing}: ${job['jobTiming'] ?? AppLocalizations.of(context)!.notSpecified}"),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: Text("${AppLocalizations.of(context)!.contact}: ${job['contactMobile'] ?? AppLocalizations.of(context)!.notProvided}")),
                if (job['contactMobile'] != null &&
                    (job['contactMobile'] as String).trim().isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _launchPhoneDialer(job['contactMobile']),
                    tooltip: AppLocalizations.of(context)!.callEmployer,
                  ),
              ],
            ),

            const SizedBox(height: 16),
            Text("${AppLocalizations.of(context)!.description}:", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(description.isEmpty ? AppLocalizations.of(context)!.noDescription : description),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
            onPressed: _alreadyApplied || _isApplying ? null : _applyForJob,
            child: _alreadyApplied
                ? Text(AppLocalizations.of(context)!.alreadyApplied)
                : _isApplying
                ? const CircularProgressIndicator()
                : Text(AppLocalizations.of(context)!.applyNow),
          ),
      ),
    );
  }
}
