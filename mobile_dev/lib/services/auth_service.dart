import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '268312084234-sgtra1lbo1ta38vd1cmp3vt517olda8a.apps.googleusercontent.com',
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
        // final GoogleSignInAuthentication auth = await account.authentication;
        // debugPrint('ID Token: ${auth.idToken}');
      }
      return account;
    } catch (error) {
      debugPrint('❌ Google Sign-In Error: $error');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() => _googleSignIn.disconnect();
}