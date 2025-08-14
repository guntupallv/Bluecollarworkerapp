import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localjobfinder/l10n/app_localizations.dart';

class EmployerEditJobScreen extends StatefulWidget {
  final String jobId;

  const EmployerEditJobScreen({super.key, required this.jobId});

  @override
  State<EmployerEditJobScreen> createState() => _EmployerEditJobScreenState();
}

class _EmployerEditJobScreenState extends State<EmployerEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobileController = TextEditingController();

  String _rateType = 'daily';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    final doc = await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get();

    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.jobNotFound)),
      );
      Navigator.pop(context);
      return;
    }

    final data = doc.data()!;
    _titleController.text = data['title'] ?? '';
    _categoryController.text = data['category'] ?? '';
    _locationController.text = data['location'] ?? '';
    _rateController.text = (data['rate'] ?? '').toString();
    _descriptionController.text = data['description'] ?? '';
    _mobileController.text = data['contactMobile'] ?? '';

    final validRateTypes = ['hourly', 'daily', 'weekly', 'monthly'];
    final fetchedRateType = data['rateType'] ?? 'hourly';
    _rateType = validRateTypes.contains(fetchedRateType) ? fetchedRateType : 'hourly';

    final timing = data['jobTiming'] ?? '';
    if (timing.contains('–')) {
      final parts = timing.split('–');
      try {
        _startTime = _parseTimeOfDay(parts[0].trim());
        _endTime = _parseTimeOfDay(parts[1].trim());
      } catch (_) {}
    }

    setState(() => _loading = false);
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final format = TimeOfDayFormat.a_space_h_colon_mm;
    final now = DateTime.now();
    final parsed = TimeOfDay.fromDateTime(DateTime.tryParse('$now $time') ?? now);
    return parsed;
  }

  String _formatTimeRange() {
    if (_startTime == null || _endTime == null) return AppLocalizations.of(context)!.notSet;
    return '${_startTime!.format(context)} – ${_endTime!.format(context)}';
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _updateJob() async {
    if (!_formKey.currentState!.validate() || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseCompleteAllFields)),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update({
        'title': _titleController.text.trim(),
        'category': _categoryController.text.trim(),
        'location': _locationController.text.trim(),
        'rate': double.tryParse(_rateController.text.trim()) ?? 0,
        'rateType': _rateType,
        'description': _descriptionController.text.trim(),
        'contactMobile': _mobileController.text.trim(),
        'jobTiming': _formatTimeRange(),
        'updatedAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.jobUpdatedSuccessfully)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.updateFailed(e.toString()))),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editJob)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobTitle),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobCategory),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.location),
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.rate),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _rateType,
                items: [
                  DropdownMenuItem(value: 'hourly', child: Text(AppLocalizations.of(context)!.perHour)),
                  DropdownMenuItem(value: 'daily', child: Text(AppLocalizations.of(context)!.perDay)),
                  DropdownMenuItem(value: 'weekly', child: Text(AppLocalizations.of(context)!.perWeek)),
                  DropdownMenuItem(value: 'monthly', child: Text(AppLocalizations.of(context)!.perMonth)),
                ],
                onChanged: (val) => setState(() => _rateType = val!),
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.rateType),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.contactMobile),
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.required : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.jobTiming, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text(_formatTimeRange(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.schedule, color: Colors.green),
                    onPressed: () => _pickTime(true),
                    tooltip: AppLocalizations.of(context)!.startTime,
                  ),
                  IconButton(
                    icon: const Icon(Icons.schedule, color: Colors.red),
                    onPressed: () => _pickTime(false),
                    tooltip: AppLocalizations.of(context)!.endTime,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.jobDescription),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saving ? null : _updateJob,
                child: _saving
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.updateJob),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
