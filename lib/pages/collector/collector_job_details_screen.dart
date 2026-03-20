import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CollectorJobDetailsScreen extends StatefulWidget {
  const CollectorJobDetailsScreen({super.key});

  @override
  State<CollectorJobDetailsScreen> createState() => _CollectorJobDetailsScreenState();
}

class _CollectorJobDetailsScreenState extends State<CollectorJobDetailsScreen> {
  Map<String, dynamic>? job;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    setState(() {
      job = args;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5D46);
    const backgroundColor = Color(0xFFF8FAF9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Job Details'),
      ),
      body: job == null
          ? const Center(child: Text('No job data.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWasteDetailsCard(job!),
                  const SizedBox(height: 24),
                  _buildPhotoSection(primaryColor, job!),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, primaryColor),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context, Color primaryColor, Color accentYellow, Map<String, dynamic> job) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text('Job Details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/collector_notifications'),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: accentYellow,
                  child: Text('PD', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: primaryColor)),
                ),
                const SizedBox(height: 16),
                Text(
                  job['businessName'] ?? job['smeName'] ?? 'Business Name',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: accentYellow, size: 16),
                    const SizedBox(width: 4),
                    Text('${job['rating'] ?? '0.0'} rating', style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.grey, size: 14),
                    SizedBox(width: 4),
                    Text('123 Main St, Lagos', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWasteDetailsCard(Map<String, dynamic> job) {
    // Map backend API fields to display fields
    final wasteType = job['category'] ?? job['type'] ?? 'N/A';
    final quantity = job['quantityRange'] ?? job['weight'] ?? 'N/A';
    final value = job['estimatedValue'] != null ? '₦${job['estimatedValue']}' : (job['price'] ?? 'N/A');
    final aiPrediction = job['aiPrediction'] ?? 'N/A';
    final aiConfidence = job['aiConfidence'] != null ? '${(job['aiConfidence'] * 100).toStringAsFixed(1)}%' : 'N/A';
    final lga = job['lga'] ?? job['distance'] ?? 'N/A';


    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhotoSection(const Color(0xFF0D5D46), job),
        const SizedBox(height: 24),
        const Text('Waste Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildDetailRow('Type', wasteType),
              _buildDetailRow('Quantity', quantity),
              _buildDetailRow('Location', lga),
              _buildDetailRow('AI Prediction', aiPrediction),
              _buildDetailRow('Confidence', aiConfidence, valueColor: const Color(0xFF0D5D46)),
              _buildDetailRow('Estimated Value', value, isBold: true, valueColor: const Color(0xFF0D5D46), fontSize: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: valueColor ?? Colors.black, fontSize: fontSize)),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(Color primaryColor, Map<String, dynamic> job) {
    const String baseUrl = 'https://wastelink-production.up.railway.app/api';
    String? imageUrl = job['imageUrl'] ?? job['photoUrl'];
   if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = imageUrl.startsWith('/') ? '$baseUrl$imageUrl' : '$baseUrl/$imageUrl';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Waste Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.hardEdge,
          child: imageUrl != null
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('Could not load image', style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No photo provided by SME', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Color primaryColor) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/collector_job_accepted'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Accept Job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text('Propose New Time', style: TextStyle(color: Colors.black87)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.red.shade100),
                ),
                child: const Text('Decline', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}