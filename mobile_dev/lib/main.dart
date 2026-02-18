import 'package:flutter/material.dart';
import 'package:wastelink/pages/login.dart';
import 'package:wastelink/pages/onboarding.dart';
import 'package:wastelink/pages/signup.dart';
import 'package:wastelink/pages/profile_screen.dart';
import 'package:wastelink/pages/dashboard_screen.dart';
void main() => runApp(const WasteLinkApp());

class WasteLinkApp extends StatelessWidget {
  const WasteLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasteLink',
      debugShowCheckedModeBanner : false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/profile_setup': (context) => const ProfileScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
