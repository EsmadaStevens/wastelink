import 'package:flutter/material.dart';

class SmeNotificationsScreen extends StatefulWidget {
  const SmeNotificationsScreen({super.key});

  @override
  State<SmeNotificationsScreen> createState() => _SmeNotificationsScreenState();
}

class _SmeNotificationsScreenState extends State<SmeNotificationsScreen> {
  String _selectedFilter = 'All';

  
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'icon': Icons.local_shipping_outlined, 'iconColor': Colors.green, 'iconBg': Colors.green.shade50,
      'title': 'Pickup Completed', 'description': 'Your waste has been collected by Adewale Okonjo',
      'time': '2 hours ago', 'isUnread': true, 'category': 'Pickups'
    },
    {
      'icon': Icons.stars, 'iconColor': Colors.blue, 'iconBg': Colors.blue.shade50,
      'title': 'Points Earned', 'description': 'You earned 40 points for logging 8kg of plastic',
      'time': '5 hours ago', 'isUnread': true, 'category': 'Rewards'
    },
    {
      'icon': Icons.card_giftcard, 'iconColor': Colors.amber, 'iconBg': Colors.amber.shade50,
      'title': 'New Reward Available', 'description': 'You have enough points to redeem a new reward',
      'time': '5 hours ago', 'isUnread': true, 'category': 'Rewards'
    },
    {
      'icon': Icons.gavel, 'iconColor': Colors.grey, 'iconBg': Colors.grey.shade100,
      'title': 'Policy Update', 'description': 'We have updated our terms of service regarding pickups',
      'time': '5 hours ago', 'isUnread': true, 'category': 'All'
    },
    {
      'icon': Icons.event_available, 'iconColor': Colors.indigo, 'iconBg': Colors.indigo.shade50,
      'title': 'Pickup Reminder', 'description': 'Your pickup is scheduled for tomorrow at 10:00 AM',
      'time': '1 day ago', 'isUnread': false, 'category': 'Pickups'
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _allNotifications;
    }
    return _allNotifications.where((notif) => notif['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005C46);
    const backgroundColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Mark all as read',
            onPressed: () {
              // TODO: Implement "Mark all as read" logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Pickups'),
                const SizedBox(width: 8),
                _buildFilterChip('Rewards'),
              ],
            ),
          ),
          Expanded(
            child: _filteredNotifications.isEmpty
                ? Center(
                    child: Text(
                      'No notifications for "$_selectedFilter"',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notif = _filteredNotifications[index];
                      return _buildNotificationItem(
                        icon: notif['icon'],
                        iconColor: notif['iconColor'],
                        iconBg: notif['iconBg'],
                        title: notif['title'],
                        description: notif['description'],
                        time: notif['time'],
                        isUnread: notif['isUnread'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.yellow.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF005C46) : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}