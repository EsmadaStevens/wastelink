import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'shared_data_service.dart'; // Import the shared service
import '../services/shared_data_service.dart'; // job type definition
import 'secure_storage_service.dart'; // To get user info

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // REAL BACKEND URL
  static const String baseUrl = 'https://wastelink-production.up.railway.app/api';

  // --- MOCK TEST CREDENTIALS (LOADED FROM .ENV) ---
  // Use getters to access dotenv variables at runtime
  static String get mockSmeEmail => dotenv.env['MOCK_SME_EMAIL'] ?? '';
  static String get mockCollectorEmail => dotenv.env['MOCK_COLLECTOR_EMAIL'] ?? '';
  static String get mockPassword => dotenv.env['MOCK_PASSWORD'] ?? '';

  /// Sign In with Email and Password
  Future<Map<String, dynamic>?> signInWithEmail(String email, String password) async {
    debugPrint('SignIn: Attempting login for $email');

    // 1. MOCK LOGIC: Check for test accounts first
    if (email == mockSmeEmail && password == mockPassword) {
      debugPrint('SignIn: Matched Mock SME account');
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return {
        'token': 'mock_sme_token_12345',
        'role': 'SME',
        'user': {'name': 'Test SME User', 'email': email, 'lga': 'Obafemi Owode', 'points': 1240, 'phone': '+2348012345678'}
      };
    }

    if (email == mockCollectorEmail && password == mockPassword) {
      debugPrint('SignIn: Matched Mock Collector account');
      await Future.delayed(const Duration(seconds: 1));
      return {
        'token': 'mock_collector_token_67890',
        'role': 'Collector',
        'user': {'name': 'Test Collector User', 'email': email, 'lga': 'Obafemi Owode', 'points': 850, 'phone': '+2348098765432'}
      };
    }

    // 2. REAL LOGIC: Call the backend
    debugPrint('SignIn: No mock match, calling Real API at $baseUrl/auth/login');
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('SignIn: API Response Status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        debugPrint('SignIn: decoded response role=${decoded['role']}');
        return decoded;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('SignIn: API Error: ');
      return null;
    }
  }

  /// Sign Up with Email
  Future<Map<String, dynamic>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
    required String lga,
  }) async {
    debugPrint('SignUp: Attempting signup for ');

    // MOCK CHECK for existing email
    if (email == mockSmeEmail || email == mockCollectorEmail) {
      debugPrint('SignUp: Email matches mock account (already in use)');
      await Future.delayed(const Duration(seconds: 1));
      return {'success': false, 'message': 'This email address is already in use.'};
    }
    
    // --- DEVELOPMENT ONLY ---
    // For any other email, simulate a successful signup.
    /*else {
      debugPrint('SignUp: Simulating success for development (Real API call disabled)');
      await Future.delayed(const Duration(seconds: 1));
      return {'success': true, 'message': 'Signup successful! Please log in.'};
    }*/
    

    
    try {
      debugPrint('SignUp: Calling Real API at $baseUrl/auth/signup');
      final url = Uri.parse('$baseUrl/auth/signup');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          // backend seems to expect uppercase role strings; convert to uppercase
          'role': role.toUpperCase(),
          'lga': lga,
        }),
      );

      debugPrint('SignUp: API Response Status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Signup successful! Please log in.'};
      } else {
        final body = jsonDecode(response.body);
        final errorMessage = body['error'] ?? 'An unknown error occurred during signup.';
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('SignUp: API Error: ');
      return {'success': false, 'message': 'Could not connect to the server. Please check your internet connection.'};
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

  /// Log Waste Data (now calls real API and sends image filename if provided)
  Future<bool> logWaste({
    required String wasteType,
    required String quantity,
    required String location,
    required String date,
    String? imagePath,
  }) async {
    // send as multipart/form-data so the server can receive actual image file
    try {
      // get auth token from secure storage
      final token = await SecureStorageService().getAuthToken();
      
      final uri = Uri.parse('$baseUrl/waste/create-waste');
      final request = http.MultipartRequest('POST', uri);
      
      // add authorization header if token exists
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      request.fields['wasteType'] = wasteType;
      request.fields['quantityRange'] = quantity;

      // optionally attach location/date if backend expects them
      if (location.isNotEmpty) {
        request.fields['location'] = location;
      }
      if (date.isNotEmpty) {
        request.fields['date'] = date;
      }

      // Add image file if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath('image', imagePath));
        }
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      
      debugPrint('logWaste: API status ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint('logWaste: Error - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('logWaste: Exception - $e');
      return false;
    }
  }

  /// Request a waste pickup (Hybrid: Live -> Fallback to Local)
  Future<Map<String, dynamic>?> requestPickup({
    required String wasteType,
    required String quantity,
    required String location,
    required String date,
    required String timeSlot,
  }) async {
    // 1. Try Real API
    try {
      final token = await SecureStorageService().getAuthToken();
      final url = Uri.parse('$baseUrl/pickup/request');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'wasteType': wasteType,
          'quantity': quantity,
          'location': location,
          'date': date,
          'timeSlot': timeSlot,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyJson = jsonDecode(response.body);
        // if job data returned, also insert locally so collectors see it immediately
        try {
          if (bodyJson is Map<String, dynamic> && bodyJson['id'] != null) {
            SharedDataService().addExternalPickup(bodyJson);
          } else {
            // fallback: server did not send full object, construct minimal entry
            final id = bodyJson['pickupId']?.toString() ?? 'job_${DateTime.now().millisecondsSinceEpoch}';
            SharedDataService().addExternalPickup({
              'id': id,
              'category': wasteType,
              'quantityRange': quantity,
              'lga': location,
              'createdAt': DateTime.now().toIso8601String(),
            });
          }
        } catch (_) {}
        return bodyJson;
      }
      // If status is not 200, we intentionally fall through to the catch block
      // or explicitly throw to trigger fallback.
      throw Exception('Live API failed');
    } catch (e) {
      // 2. Fallback to Local SharedDataService
      debugPrint('Live API failed ($e), using local fallback.');
      
      final smeName = await SecureStorageService().getUserName() ?? 'Unknown SME';
      final jobId = SharedDataService().createPickupRequest(
        smeName: smeName,
        wasteType: wasteType,
        quantity: quantity,
        location: location,
        date: date,
        timeSlot: timeSlot,
      );

      return {'pickupId': jobId, 'status': 'Available (Local)'};
    }
  }

  /// Fetch list of available waste items for collectors from backend - filters to pending only
  Future<List<Map<String, dynamic>>> getAvailableWaste() async {
    try {
      final token = await SecureStorageService().getAuthToken();
      final url = Uri.parse('$baseUrl/pickup/available-waste');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          // Filter to only pending jobs
          final pending = data
              .where((job) => (job['status'] ?? '').toString().toLowerCase() == 'pending')
              .toList();
          return List<Map<String, dynamic>>.from(pending);
        }
      } else {
        debugPrint('getAvailableWaste: unexpected status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('getAvailableWaste: error $e');
    }
    // fall back to empty list
    return [];
  }

  /// Get a single job's details by its ID
  Future<PickupJob?> getJobById(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SharedDataService().getJobById(jobId);
  }

  /// Accept a job (called by a collector)
  Future<bool> acceptJob(String jobId) async {
    final collectorName = await SecureStorageService().getUserName() ?? 'Unknown Collector';
    final collectorPhone = await SecureStorageService().getUserPhone() ?? 'N/A';

    final success = SharedDataService().acceptJob(
      jobId: jobId,
      collectorInfo: {
        'name': collectorName,
        'phone': collectorPhone,
      },
    );
    return success;
  }

  /// Redeem a reward
  Future<bool> redeemReward({required String rewardId, required int pointsCost}) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
