import 'package:flutter/material.dart';
import 'package:wastelink/pages/auth_check_screen.dart';
import 'package:wastelink/pages/forgot_password.dart';
import 'package:wastelink/pages/home_screen.dart';
import 'package:wastelink/pages/login.dart';
import 'package:wastelink/pages/onboarding.dart';
import 'package:wastelink/pages/signup.dart';
import 'package:wastelink/pages/log_waste_step1_screen.dart';
import 'package:wastelink/pages/log_waste_step2_screen.dart';
import 'package:wastelink/pages/log_waste_step3_screen.dart';

void main() {
  // Ensures that plugin services are initialized before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wastelink',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheckScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignupScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/log_waste_step1': (context) => const LogWasteStep1Screen(),
        '/log_waste_step2': (context) => const LogWasteStep2Screen(),
        '/log_waste_step3': (context) => const LogWasteStep3Screen(),
      },
    );
  }
}