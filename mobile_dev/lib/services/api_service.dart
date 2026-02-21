import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http; // Commented out for now
import 'secure_storage_service.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // static const String baseUrl = 'http://10.0.2.2:6000/api'; // Commented out

  /// Helper method to create authenticated headers.
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await SecureStorageService().getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetches the user's profile to validate an existing token.
  Future<Map<String, dynamic>?> getUserProfile() async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return {
      'name': 'Test User',
      'email': 'test@example.com',
      'role': 'User',
    };
  }

  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
    required String lga,
  }) async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 1000));
    debugPrint("✅ Mock Sign-up successful for $email");
    return true;
  }

  Future<Map<String, dynamic>?> signInWithEmail(String email, String password) async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 1000));
    debugPrint("✅ Mock Sign-in successful");
    return {
      'token': 'mock_token_12345',
      'user': {
        'name': 'Test User',
        'email': email,
      }
    };
  }
  
  Future<Map<String, dynamic>?> googleAuth({
    required String email,
    required String name,
    required String googleId,
    String? photoUrl,
  }) async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 1000));
    return {
      'token': 'mock_google_token_12345',
      'user': {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      }
    };
  }

  Future<bool> sendOtp(String email) async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 1000));
    // Accept any 6 digit OTP for testing
    return otp.length == 6;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    // MOCK RESPONSE
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}