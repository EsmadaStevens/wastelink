import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final storage = SecureStorageService();
    final token = await storage.getAuthToken();

    // 1. Check if user is logged in
    if (token != null) {
      final userProfile = await ApiService().getUserProfile();
      if (mounted) {
        if (userProfile != null) {
          Navigator.of(context).pushReplacementNamed('/home');
          return;
        } else {
          await storage.deleteAuthToken();
        }
      }
    }

    // 2. If not logged in, check if they have seen onboarding
    final hasSeenOnboarding = await storage.hasSeenOnboarding();

    if (mounted) {
      if (hasSeenOnboarding) {
        // User has seen onboarding before -> Go to Login
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        // First time user -> Go to Onboarding
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF064E3B)),
      ),
    );
  }
}