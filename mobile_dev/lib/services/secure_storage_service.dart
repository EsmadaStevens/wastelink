import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();

  // --- Keys ---
  static const _tokenKey = 'authToken';
  static const _roleKey = 'userRole';
  static const _nameKey = 'userName';
  static const _emailKey = 'userEmail';
  static const _phoneKey = 'userPhone';
  static const _lgaKey = 'userLga';
  static const _pointsKey = 'userPoints';
  static const _onboardingKey = 'hasSeenOnboarding';

  // --- Auth Token ---
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteAuthToken() async {
    // Deletes all user-specific data for a clean logout
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _nameKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _phoneKey);
    await _storage.delete(key: _lgaKey);
    await _storage.delete(key: _pointsKey);
  }

  // --- User Role ---
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _roleKey);
  }

  // --- User Details (Combined for efficiency) ---
  Future<void> saveUserDetails(Map<String, dynamic> user) async {
    if (user['name'] != null) await _storage.write(key: _nameKey, value: user['name']);
    if (user['email'] != null) await _storage.write(key: _emailKey, value: user['email']);
    if (user['phone'] != null) await _storage.write(key: _phoneKey, value: user['phone']);
    if (user['lga'] != null) await _storage.write(key: _lgaKey, value: user['lga']);
    if (user['points'] != null) {
      await _storage.write(key: _pointsKey, value: user['points'].toString());
    }
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _nameKey);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<String?> getUserPhone() async {
    return await _storage.read(key: _phoneKey);
  }

  Future<int> getUserPoints() async {
    final pointsString = await _storage.read(key: _pointsKey);
    return int.tryParse(pointsString ?? '0') ?? 0;
  }

  // --- Onboarding ---
  Future<void> setHasSeenOnboarding(bool value) async {
    await _storage.write(key: _onboardingKey, value: value.toString());
  }

  Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }
}