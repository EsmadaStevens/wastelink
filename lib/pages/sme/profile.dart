import 'package:flutter/material.dart';
import '../../services/secure_storage_service.dart';

// --- Constants ---
const Color primaryColor = Color(0xFF005C46);
const Color backgroundColor = Color(0xFFF8F9FA);
const Color cardColor = Colors.white;
// ---

class SmeProfileScreen extends StatefulWidget {
  const SmeProfileScreen({super.key});

  @override
  State<SmeProfileScreen> createState() => _SmeProfileScreenState();
}

class _SmeProfileScreenState extends State<SmeProfileScreen> {
  String _userName = "Loading...";
  String _userRole = "";
  String _userInitials = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = SecureStorageService();
    // In a real app, you might make one API call to get a full user profile.
    // For now, we fetch individual pieces from secure storage.
    final name = await storage.getUserName() ?? "SME User";
    final role = await storage.getUserRole() ?? "SME";

    if (mounted) {
      setState(() {
        _userName = name;
        _userRole = role;
        _userInitials = _getInitials(name);
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> words = name.split(" ").where((s) => s.isNotEmpty).toList();
    if (words.length > 1) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return "";
  }

  Future<void> _handleLogout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await SecureStorageService().deleteAuthToken();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(primaryColor),
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: _buildStatsCard(),
                  ),
                  _buildMenuList(context),
                  const SizedBox(height: 20),
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
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 40),
      color: primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/sme_notifications'),
                child: const Icon(Icons.notifications, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.yellow,
            child: Text(_userInitials, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
          ),
          const SizedBox(height: 12),
          Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag(_userRole == 'SME' ? 'Small & Medium Enterprise' : _userRole, Colors.white.withValues(alpha: 0.2)),
              const SizedBox(width: 8),
              _buildTag('Verified', Colors.green.withValues(alpha:0.3), icon: Icons.check_circle),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to Edit Profile Screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            ),
            child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 12),
          if (icon != null) const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '127.5', label: 'Kg logged'),
          _StatItem(value: '23', label: 'Pickups'),
          _StatItem(value: '1,240', label: 'Points'),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.person_outline,
            title: 'Account Settings',
            onTap: () => Navigator.pushNamed(context, '/sme_account_settings'),
          ),
          _MenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notification Preferences',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.security_outlined,
            title: 'Privacy & Data',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.description_outlined,
            title: 'Terms & Policies',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.red.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.1)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 2),
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF334155))),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}