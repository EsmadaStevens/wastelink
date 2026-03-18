import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/shared_data_service.dart';

class CollectorAvailableJobsScreen extends StatefulWidget {
  const CollectorAvailableJobsScreen({super.key});

  @override
  State<CollectorAvailableJobsScreen> createState() => _CollectorAvailableJobsScreenState();
}

class _CollectorAvailableJobsScreenState extends State<CollectorAvailableJobsScreen> {
  List<Map<String, dynamic>> _jobs = [];
  bool _loadingJobs = true;
  bool _usingLocalFallback = false;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
    SharedDataService().availableJobsNotifier.addListener(_onLocalJobs);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchJobs();
  }

  void _onLocalJobs() {
    // Only update if using local fallback
    if (!_usingLocalFallback) return;
    setState(() {
      _jobs = SharedDataService().availableJobsNotifier.value
        .map((PickupJob job) => {
          'id': job.id,
          'category': job.wasteType,
          'quantityRange': job.quantity,
          'status': job.status,
          'estimatedValue': job.estimatedValue ?? null,
          'businessName': job.smeName,
          'lga': job.location ?? '',
          'aiPrediction': job.aiPrediction ?? '',
          'aiConfidence': job.aiConfidence ?? null,
        }).toList();
    });
  }

  @override
  void dispose() {
    SharedDataService().availableJobsNotifier.removeListener(_onLocalJobs);
    super.dispose();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _loadingJobs = true;
      _usingLocalFallback = false;
    });
    try {
      final jobsRaw = await ApiService().getAvailableWaste();
      final localJobs = SharedDataService().availableJobsNotifier.value
        .map((PickupJob job) => {
          'id': job.id,
          'category': job.wasteType,
          'quantityRange': job.quantity,
          'status': job.status,
          'estimatedValue': job.estimatedValue ?? null,
          'businessName': job.smeName,
          'lga': job.location ?? '',
          'aiPrediction': job.aiPrediction ?? '',
          'aiConfidence': job.aiConfidence ?? null,
        }).toList();
      // Merge backend and local jobs, avoiding duplicates by id
      final allJobs = <Map<String, dynamic>>[];
      final seenIds = <String>{};
      for (var job in jobsRaw) {
        final id = job['id']?.toString() ?? '';
        if (id.isNotEmpty) seenIds.add(id);
        allJobs.add(job);
      }
      for (var job in localJobs) {
        final id = job['id']?.toString() ?? '';
        if (id.isNotEmpty && !seenIds.contains(id)) {
          allJobs.add(job);
        }
      }
      if (!mounted) return;
      setState(() {
        _jobs = allJobs;
        _loadingJobs = false;
        _usingLocalFallback = false;
      });
    } catch (_) {
      // Fallback to local jobs if API fails
      setState(() {
        _jobs = SharedDataService().availableJobsNotifier.value
          .map((PickupJob job) => {
            'id': job.id,
            'category': job.wasteType,
            'quantityRange': job.quantity,
            'status': job.status,
            'estimatedValue': job.estimatedValue ?? null,
            'businessName': job.smeName,
            'lga': job.location ?? '',
            'aiPrediction': job.aiPrediction ?? '',
            'aiConfidence': job.aiConfidence ?? null,
          }).toList();
        _loadingJobs = false;
        _usingLocalFallback = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF014B3E);
    const backgroundColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Available Jobs', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _fetchJobs,
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_jobs.length} Jobs Nearby', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _fetchJobs,
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Filters'),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loadingJobs
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => _fetchJobs(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _jobs.length,
                      itemBuilder: (context, index) {
                        final job = _jobs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildJobCard(context, primaryColor, job),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Color primaryColor, Map<String, dynamic> job) {
    final category = job['category'] ?? 'Unknown';
    final qtyRange = job['quantityRange'] ?? '';
    final value = job['estimatedValue'] != null ? '₦${job['estimatedValue']}' : '';
    final status = job['status'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(qtyRange, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  if (status.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(status.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/collector_job_details', arguments: job);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("View Details", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}