import 'package:flutter/material.dart';
import '../../services/secure_storage_service.dart';

class SmeAccountSettingsScreen extends StatefulWidget {
  const SmeAccountSettingsScreen({super.key});

  @override
  State<SmeAccountSettingsScreen> createState() => _SmeAccountSettingsScreenState();
}

class _SmeAccountSettingsScreenState extends State<SmeAccountSettingsScreen> {
  String _email = 'Loading...';
  String _phone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = SecureStorageService();
    final email = await storage.getUserEmail() ?? 'not-found@wastelink.com';
    final phone = await storage.getUserPhone() ?? 'N/A';
    if (mounted) {
      setState(() {
        _email = email;
        _phone = phone;
      });
    }
  }

  Future<void> _handleDeleteAccount() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      // TODO: Call an API to delete the account on the backend
      await SecureStorageService().deleteAuthToken();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF006442);
    const backgroundColor = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Account Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your account information',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildProfileButton(),
            const SizedBox(height: 16),
            _buildInfoCard(
              label: 'Email',
              value: _email,
              onChanged: () {
                // TODO: Navigate to a "Change Email" screen
              },
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              label: 'Phone',
              value: _phone,
              onChanged: () {
                // TODO: Navigate to a "Change Phone" screen
              },
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              label: 'Password',
              value: '••••••••',
              onChanged: () {
                // Navigate to the start of the password reset flow
                Navigator.pushNamed(context, '/forgot_password');
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _handleDeleteAccount,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.red.withValues(alpha: 0.05),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withValues(alpha:0.1)),
                  ),
                ),
                child: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton() {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: () {
          // TODO: Navigate to an "Edit Profile" screen
        },
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF006442),
          foregroundColor: Colors.white,
          child: Icon(Icons.person_outline),
        ),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Update your personal information'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required VoidCallback onChanged,
  }) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            TextButton(
              onPressed: onChanged,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF006442).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFF006442),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}