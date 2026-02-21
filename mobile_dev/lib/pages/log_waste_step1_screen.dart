import 'package:flutter/material.dart';

class LogWasteStep1Screen extends StatefulWidget {
  const LogWasteStep1Screen({super.key});

  @override
  State<LogWasteStep1Screen> createState() => _LogWasteStep1ScreenState();
}

class _LogWasteStep1ScreenState extends State<LogWasteStep1Screen> {
  String? _selectedType;

  final List<Map<String, dynamic>> _wasteTypes = [
    {'icon': Icons.recycling, 'label': 'Plastic'},
    {'icon': Icons.description, 'label': 'Paper'},
    {'icon': Icons.inventory_2, 'label': 'Metal'},
    {'icon': Icons.wine_bar, 'label': 'Glass'},
    {'icon': Icons.eco, 'label': 'Organic'},
    {'icon': Icons.widgets, 'label': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDFB),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF005841),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Log Waste",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Serif',
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const Icon(Icons.notifications,
                            color: Colors.white, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE600),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF005841), width: 2),
                            ),
                          ),
                        ),
                      ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Step 1 of 3",
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          _buildDot(true),
                          const SizedBox(width: 8),
                          _buildDot(false),
                          const SizedBox(width: 8),
                          _buildDot(false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text("What are you logging?",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Serif',
                          fontWeight: FontWeight.bold)),
                  Text("Select the type of waste you're logging",
                      style: TextStyle(color: Colors.grey.shade500)),
                  const SizedBox(height: 32),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _wasteTypes.length,
                    itemBuilder: (context, index) {
                      final type = _wasteTypes[index];
                      final isSelected = _selectedType == type['label'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedType = type['label'];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF0F9F6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF005841)
                                  : Colors.grey.shade100,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                type['icon'],
                                size: 40,
                                color: Colors.grey.shade800,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                type['label'],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedType != null
                          ? () {
                              Navigator.pushNamed(context, '/log_waste_step2',
                                  arguments: _selectedType);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005841),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Text("Continue",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
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
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF005841) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
    );
  }
}