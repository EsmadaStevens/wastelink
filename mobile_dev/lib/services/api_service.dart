import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // REAL BACKEND URL
  static const String baseUrl = 'https://wastelink-production.up.railway.app';

  // --- MOCK TEST CREDENTIALS ---
  static const String mockSmeEmail = 'sme@test.com';
  static const String mockCollectorEmail = 'collector@test.com';
  static const String mockPassword = 'password123';

  /// Sign In with Email and Password
  Future<Map<String, dynamic>?> signInWithEmail(String email, String password) async {
    // 1. MOCK LOGIC: Check for test accounts first
    if (email == mockSmeEmail && password == mockPassword) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return {
        'token': 'mock_sme_token_12345',
        'role': 'SME',
        'user': {'name': 'Test SME User', 'email': email, 'lga': 'Obafemi Owode', 'points': 1240, 'phone': '+2348012345678'}
      };
    }

    if (email == mockCollectorEmail && password == mockPassword) {
      await Future.delayed(const Duration(seconds: 1));
      return {
        'token': 'mock_collector_token_67890',
        'role': 'Collector',
        'user': {'name': 'Test Collector User', 'email': email, 'lga': 'Obafemi Owode', 'points': 850, 'phone': '+2348098765432'}
      };
    }

    // 2. REAL LOGIC: Call the backend
    try {
      final url = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Sign Up with Email
  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
    required String lga,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/signup');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'lga': lga,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Google Auth (Mocked for now)
  Future<Map<String, dynamic>?> googleAuth({
    required String email,
    required String name,
    required String googleId,
    String? photoUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'token': 'mock_google_token',
      'role': 'SME',
    };
  }

  /// Send OTP for Password Reset
  Future<bool> sendOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Verify OTP
  Future<bool> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp.length == 6;
  }

  /// Reset Password
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Log Waste Data
  Future<bool> logWaste({
    required String wasteType,
    required String quantity,
    required String location,
    required String date,
    String? imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Request a waste pickup
  Future<Map<String, dynamic>?> requestPickup({
    required String date,
    required String timeSlot,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return {
      'pickupId': 'pickup_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'Assigned', // Initial status
      'collector': {
        'name': 'Adewale Okonjo',
        'phone': '+2348012345678',
        'rating': '4.8',
      }
    };
  }

  /// Redeem a reward
  Future<bool> redeemReward({required String rewardId, required int pointsCost}) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}