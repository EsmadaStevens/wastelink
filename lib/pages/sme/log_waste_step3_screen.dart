import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class LogWasteStep3Screen extends StatefulWidget {
  const LogWasteStep3Screen({super.key});

  @override
  State<LogWasteStep3Screen> createState() => _LogWasteStep3ScreenState();
}

class _LogWasteStep3ScreenState extends State<LogWasteStep3Screen> {
  Map<String, dynamic>? _logData;
  bool _isSubmitting = true; // Start in a loading state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && _logData == null) {
      _logData = args;
      _submitWasteLog();
    }
  }

  Future<void> _submitWasteLog() async {
    if (_logData == null) return;

    // Call the API to log the waste
    final success = await ApiService().logWaste(
      wasteType: _logData!['wasteType'],
      quantity: _logData!['quantity'],
      location: _logData!['location'],
      date: _logData!['date'],
      imagePath: _logData!['imagePath'],
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to log waste. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            color: const Color(0xFF005844),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Log Waste",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade400,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF005844), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Step 3 of 3",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          _buildDot(false),
                          const SizedBox(width: 6),
                          _buildDot(false),
                          const SizedBox(width: 6),
                          _buildDot(true),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Success Card
                  if (_isSubmitting)
                    const Center(child: CircularProgressIndicator(color: Color(0xFF005844)))
                  else
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 96,
                            width: 96,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                              ],
                            ),
                            child: const Icon(Icons.check, size: 48, color: Color(0xFF005844)),
                          ),
                          const SizedBox(height: 24),
                          const Text("Waste Logged!",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF005844))),
                          const SizedBox(height: 8),
                          Text("You earned 35 points",
                              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 32),
                          _buildDetailRow("Waste Type:", _logData?['wasteType'] ?? "N/A"),
                          _buildDetailRow("Quantity:", "${_logData?['quantity'] ?? '0'} kg"),
                          _buildDetailRow("Points Earned:", "35 pts", isLast: true),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005844),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                              ),
                              child: const Text("Back to Home",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, '/sme_rewards_marketplace'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF005844),
                                side: const BorderSide(color: Color(0xFF005844), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text("View Rewards",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF005844) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF005844), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
