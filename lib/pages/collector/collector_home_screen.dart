import 'package:flutter/material.dart';
import '../../services/secure_storage_service.dart';

class CollectorHomeScreen extends StatefulWidget {
  const CollectorHomeScreen({super.key});

  @override
  State<CollectorHomeScreen> createState() => _CollectorHomeScreenState();
}

class _CollectorHomeScreenState extends State<CollectorHomeScreen> {
  String _userName = "Collector";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await SecureStorageService().getUserName();
    if (mounted && name != null) {
      setState(() {
        _userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005C46);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(primaryColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildOverviewSection(),
                  const SizedBox(height: 24),
                  _buildAvailableJobsSection(context, primaryColor),
                  const SizedBox(height: 24),
                  _buildScheduleSection(primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('WasteLink', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.recycling, color: Colors.white, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Good afternoon, $_userName',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), 
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/collector_notifications'),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildOverviewCard(
          icon: Icons.payments,
          iconColor: Colors.green,
          bgColor: Colors.green.shade50,
          label: "Total Points",
          value: "1,240",
          suffix: "pts"
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                icon: Icons.assignment_turned_in,
                iconColor: Colors.blue,
                bgColor: Colors.blue.shade50,
                label: "Jobs Completed",
                value: "8",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                icon: Icons.stars,
                iconColor: Colors.amber,
                bgColor: Colors.amber.shade50,
                label: "Jobs Available",
                value: "3",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
    String? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: iconColor.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    text: value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor.withValues(alpha: 0.9)),
                    children: suffix != null
                        ? [TextSpan(text: ' ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal))]
                        : [],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableJobsSection(BuildContext context, Color primaryColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Available Jobs Nearby", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/collector_available_jobs_screen'),
              child: Text("View All", style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                        child: Text("Urgent", style: TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 4),
                      const Text("Padini Business Solutions", style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text("Plastic • 15 kg", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Text("₦600", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("View Details"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildScheduleItem("10:00 AM", "Lagos Market", "₦550", "Done", Colors.green),
        const SizedBox(height: 8),
        _buildScheduleItem("2:00 PM", "Office Complex", "₦650", "Active", Colors.green, isActive: true),
        const SizedBox(height: 8),
        _buildScheduleItem("4:00 PM", "Restaurant Row", "₦700", "Pending", Colors.grey),
      ],
    );
  }

  Widget _buildScheduleItem(String time, String location, String price, String status, Color color, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.green.shade200 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(price, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.white : color),
            ),
          ),
        ],
      ),
    );
  }
}
