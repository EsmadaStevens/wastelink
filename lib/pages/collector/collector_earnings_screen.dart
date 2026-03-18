import 'package:flutter/material.dart';

class CollectorEarningsScreen extends StatelessWidget {
  const CollectorEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF065F46);
    const backgroundColor = Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _buildHeader(primaryColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalEarningsCard(primaryColor),
                  const SizedBox(height: 32),
                  _buildEarningsByWasteType(primaryColor),
                  const SizedBox(height: 32),
                  _buildPaymentHistory(primaryColor),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 20),
                      label: const Text('Download Full Report', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
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
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      color: primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Earnings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Track your income', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('This Week', textAlign: TextAlign.center, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('This Month', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalEarningsCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Earnings', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text('₦24,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.payments, color: Color(0xFFA7F3D0)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Jobs', '42'),
              _buildStatItem('Average', '₦583'),
              _buildStatItem('Growth', '+12%', valueColor: const Color(0xFF6EE7B7), icon: Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? valueColor, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) Icon(icon, color: valueColor, size: 16),
            if (icon != null) const SizedBox(width: 4),
            Text(value, style: TextStyle(color: valueColor ?? Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsByWasteType(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Earnings by Waste Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildWasteTypeBar('Plastic', '₦10,800', '18 jobs', 0.75, primaryColor),
        const SizedBox(height: 16),
        _buildWasteTypeBar('Paper', '₦7,200', '12 jobs', 0.50, primaryColor),
        const SizedBox(height: 16),
        _buildWasteTypeBar('Organic', '₦4,800', '8 jobs', 0.35, primaryColor),
        const SizedBox(height: 16),
        _buildWasteTypeBar('Other', '₦1,700', '4 jobs', 0.15, primaryColor),
      ],
    );
  }

  Widget _buildWasteTypeBar(String label, String amount, String jobs, double percentage, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(jobs, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistory(Color primaryColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.file_download, size: 16, color: primaryColor),
              label: Text('EXPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPaymentItem('Feb 18, 2026', '8 jobs completed', '₦4,500', 'Paid', const Color(0xFFDEF7EC), const Color(0xFF03543F)),
        const SizedBox(height: 12),
        _buildPaymentItem('Feb 16, 2026', '9 jobs completed', '₦5,200', 'Paid', const Color(0xFFDEF7EC), const Color(0xFF03543F)),
        const SizedBox(height: 12),
        _buildPaymentItem('Feb 15, 2026', '7 jobs completed', '₦4,100', 'Pending', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
        const SizedBox(height: 12),
        _buildPaymentItem('Feb 14, 2026', '6 jobs completed', '₦3,800', 'Paid', const Color(0xFFDEF7EC), const Color(0xFF03543F)),
      ],
    );
  }

  Widget _buildPaymentItem(String date, String subtitle, String amount, String status, Color statusBg, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                child: Text(status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}