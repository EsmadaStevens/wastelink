import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();
  static const _authTokenKey = 'authToken';
  static const _onboardingKey = 'hasSeenOnboarding';

  /// Saves the authentication token.
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  /// Retrieves the authentication token.
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  /// Deletes the authentication token.
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  // --- NEW METHODS FOR ONBOARDING ---

  /// Marks the onboarding as completed.
  Future<void> setOnboardingComplete() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  /// Checks if onboarding has been seen.
  Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }
  
  /// Optional: Reset onboarding (useful for testing/debug)
  Future<void> clearOnboarding() async {
    await _storage.delete(key: _onboardingKey);
  }
}