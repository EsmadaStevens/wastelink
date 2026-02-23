import 'package:flutter/material.dart';
import 'pages/auth_check_screen.dart';
import 'pages/onboarding_screen.dart';
import 'pages/login_screen.dart';
import 'pages/signup_screen.dart';
import 'pages/forgot_password_screen.dart';
import 'pages/otp_verification_screen.dart';
import 'pages/reset_password_screen.dart';
import 'pages/password_changed_success_screen.dart';
import 'pages/sme/sme_main_screen.dart';
import 'pages/sme/pickup_screen.dart';
import 'pages/sme/pickup_tracking_screen.dart';
import 'pages/sme/rewards_marketplace_screen.dart';
import 'pages/sme/reward_redemption_screen.dart';
import 'pages/sme/reward_success_screen.dart';
import 'pages/sme/account_settings_screen.dart';
import 'pages/sme/notifications_screen.dart';
import 'pages/sme/log_waste_step1_screen.dart';
import 'pages/sme/log_waste_step2_screen.dart';
import 'pages/sme/log_waste_step3_screen.dart';
import 'pages/collector/collector_main_screen.dart';
import 'pages/collector/collector_job_details_screen.dart';
import 'pages/collector/collector_job_accepted_screen.dart';
import 'pages/collector/collector_navigation_screen.dart';
import 'pages/collector/collector_pickup_confirmation_screen.dart';

void main() {
  runApp(const WasteLinkApp());
}

class WasteLinkApp extends StatelessWidget {
  const WasteLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasteLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF064E3B),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF064E3B)),
        useMaterial3: true,
        fontFamily: 'Serif',
      ),
      home: const AuthCheckScreen(),
      routes: {
        // Auth Flow
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/otp_verification': (context) => const OtpVerificationScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/password_changed_success': (context) => const PasswordChangedSuccessScreen(),

        // SME Flow
        '/home': (context) => const SmeMainScreen(),
        '/sme_pickup': (context) => const SmePickupScreen(),
        '/sme_pickup_tracking': (context) => const SmePickupTrackingScreen(),
        '/sme_rewards_marketplace': (context) => const SmeRewardsMarketplaceScreen(),
        '/sme_reward_redemption': (context) => const SmeRewardRedemptionScreen(),
        '/sme_reward_success': (context) => const SmeRewardSuccessScreen(),
        '/sme_account_settings': (context) => const SmeAccountSettingsScreen(),
        '/sme_notifications': (context) => const SmeNotificationsScreen(),
        '/log_waste_step1': (context) => const LogWasteStep1Screen(),
        '/log_waste_step2': (context) => const LogWasteStep2Screen(),
        '/log_waste_step3': (context) => const LogWasteStep3Screen(),

        // Collector Flow
        '/collector_home': (context) => const CollectorMainScreen(),
        '/collector_job_details': (context) => const CollectorJobDetailsScreen(),
        '/collector_job_accepted': (context) => const CollectorJobAcceptedScreen(),
        '/collector_navigation': (context) => const CollectorNavigationScreen(),
        '/collector_pickup_confirmation': (context) => const CollectorPickupConfirmationScreen(),
      },
    );
  }
}
