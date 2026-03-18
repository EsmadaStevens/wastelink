import 'package:flutter/material.dart';

class CollectorNotificationsScreen extends StatelessWidget {
  const CollectorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF014B3E);
    const backgroundColor = Color(0xFFF8FAFC);

    // Mock Notification Data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Job Nearby',
        'message': 'A new plastic waste pickup is available 2km away in Ikeja.',
        'time': '2 mins ago',
        'isUnread': true,
        'type': 'job',
      },
      {
        'title': 'Payment Received',
        'message': 'You received ₦4,500 for the pickup at Padini Business Solutions.',
        'time': '1 hour ago',
        'isUnread': true,
        'type': 'payment',
      },
      {
        'title': 'Job Accepted',
        'message': 'You have successfully accepted the job #8821. Head to the location.',
        'time': '3 hours ago',
        'isUnread': false,
        'type': 'job_update',
      },
      {
        'title': 'System Update',
        'message': 'Please verify your vehicle documents to maintain your verified status.',
        'time': '1 day ago',
        'isUnread': false,
        'type': 'system',
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (notification['type']) {
      case 'payment':
        icon = Icons.account_balance_wallet;
        iconColor = Colors.green;
        iconBg = Colors.green.shade50;
        break;
      case 'job':
        icon = Icons.location_on;
        iconColor = Colors.orange;
        iconBg = Colors.orange.shade50;
        break;
      case 'job_update':
        icon = Icons.check_circle;
        iconColor = const Color(0xFF014B3E);
        iconBg = const Color(0xFFE0F2F1);
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.blue;
        iconBg = Colors.blue.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification['isUnread'] ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isUnread'] ? Colors.grey.shade200 : Colors.transparent,
        ),
        boxShadow: notification['isUnread']
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
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
                    Text(
                      notification['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: notification['isUnread'] ? Colors.black : Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      notification['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: TextStyle(
                    color: notification['isUnread'] ? Colors.grey.shade800 : Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}