import 'package:flutter/material.dart';

enum SmeNavTab { home, log, pickup, rewards, profile }

class SmeBottomNavBar extends StatelessWidget {
  final SmeNavTab activeTab;
  final Function(SmeNavTab) onTabSelected;

  const SmeBottomNavBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005C46);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            isActive: activeTab == SmeNavTab.home,
            onTap: () => onTabSelected(SmeNavTab.home),
            primaryColor: primaryColor,
          ),
          _buildNavItem(
            icon: Icons.receipt_long,
            label: 'Log',
            isActive: activeTab == SmeNavTab.log,
            onTap: () => onTabSelected(SmeNavTab.log),
            primaryColor: primaryColor,
          ),
          _buildNavItem(
            icon: Icons.local_shipping,
            label: 'Pickup',
            isActive: activeTab == SmeNavTab.pickup,
            onTap: () => onTabSelected(SmeNavTab.pickup),
            primaryColor: primaryColor,
          ),
          _buildNavItem(
            icon: Icons.card_giftcard,
            label: 'Rewards',
            isActive: activeTab == SmeNavTab.rewards,
            onTap: () => onTabSelected(SmeNavTab.rewards),
            primaryColor: primaryColor,
          ),
          _buildNavItem(
            icon: Icons.person,
            label: 'Profile',
            isActive: activeTab == SmeNavTab.profile,
            onTap: () => onTabSelected(SmeNavTab.profile),
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    final color = isActive ? primaryColor : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}