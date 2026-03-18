import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class SmeRewardRedemptionScreen extends StatefulWidget {
  const SmeRewardRedemptionScreen({super.key});

  @override
  State<SmeRewardRedemptionScreen> createState() => _SmeRewardRedemptionScreenState();
}

class _SmeRewardRedemptionScreenState extends State<SmeRewardRedemptionScreen> {
  Map<String, dynamic>? _rewardData;
  bool _isLoading = false;
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _rewardData = args;
    }
  }

  Future<void> _handleRedeem() async {
    if (_rewardData == null) return;

    setState(() => _isLoading = true);

    final success = await ApiService().redeemReward(
      rewardId: 'reward_1', 
      pointsCost: _rewardData!['pointsCost'],
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/sme_reward_success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Redemption failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF006442);
    const backgroundColor = Color(0xFFF8FAFC);

    final title = _rewardData?['title'] ?? 'Reward';
    final subtitle = _rewardData?['subtitle'] ?? '';
    final pointsCost = _rewardData?['pointsCost'] ?? 0;
    final currentPoints = _rewardData?['currentPoints'] ?? 0;
    final newBalance = currentPoints - pointsCost;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Redeem Reward', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(Icons.payments_outlined, size: 40, color: Color(0xFF059669)),
                        ),
                        const SizedBox(height: 16),
                        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('POINTS REQUIRED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                              const SizedBox(width: 8),
                              Text('${_formatter.format(pointsCost)} pts', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _BalanceRow(label: 'Current Balance', value: '${_formatter.format(currentPoints)} pts'),
                  const Divider(height: 32),
                  _BalanceRow(label: 'Cost', value: '-${_formatter.format(pointsCost)} pts', valueColor: Colors.red),
                  const Divider(height: 32),
                  _BalanceRow(label: 'New Balance', value: '${_formatter.format(newBalance)} pts', valueColor: primaryColor, isBold: true),
                  const SizedBox(height: 32),
                  const Text(
                    "* Your points will be deducted immediately upon redemption. You can view your active vouchers in the 'My Rewards' section.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRedeem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Redeem Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _BalanceRow({required this.label, required this.value, this.valueColor, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: const Color(0xFF475569), fontWeight: isBold ? FontWeight.w600 : FontWeight.normal)),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }
}