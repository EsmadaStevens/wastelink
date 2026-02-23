import 'package:flutter/material.dart';
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
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final storage = SecureStorageService();
    final token = await storage.getAuthToken();
    final hasSeenOnboarding = await storage.hasSeenOnboarding();

    if (!mounted) return;

    if (token != null) {
      final role = await storage.getUserRole();
      if (role == 'Collector') {
        Navigator.of(context).pushReplacementNamed('/collector_home');
      } else {
        // Default to SME home
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else if (hasSeenOnboarding) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFF064E3B))),
    );
  }
}