import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'secure_storage_service.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '268312084234-78mffkjssf6cntca059enrcgto7vm428.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
    ],
  );

  /// Trigger the Google Sign-In flow
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        debugPrint('✅ Signed in: ${account.displayName}');
        final GoogleSignInAuthentication auth = await account.authentication;
        debugPrint('ID Token: ${auth.idToken}');
      }
      return account;
    } catch (error) {
      debugPrint('❌ Google Sign-In Error: $error');
      
      // Error handling for common Google Play Services issues
      if (error.toString().contains('12500') || 
          error.toString().contains('SERVICE_INVALID') ||
          error.toString().contains('Google Play Store')) {
        debugPrint('⚠️  Google Play Services not available on this device/emulator.');
        debugPrint('💡 Solutions:');
        debugPrint('   1. Use a physical device with Google Play Store');
        debugPrint('   2. Use an emulator with Google Play image (API 30+)');
        debugPrint('   3. Or use email login as fallback');
      }
      
      return null;
    }
  }

  /// Sign out and clear all stored credentials
  Future<void> signOut() async {
    // Disconnect Google Sign-In
    await _googleSignIn.disconnect();
    // Clear all stored auth data
    await SecureStorageService().deleteAuthToken();
  }
}