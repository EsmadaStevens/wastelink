import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();
  static const _authTokenKey = 'authToken';
  static const _onboardingKey = 'hasSeenOnboarding';
  static const _roleKey = 'userRole';
  static const _nameKey = 'userName';
  static const _emailKey = 'userEmail';
  static const _lgaKey = 'userLGA';
  static const _phoneKey = 'userPhone';
  static const _pointsKey = 'userPoints';

  // --- Auth Token ---
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _nameKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _lgaKey);
    await _storage.delete(key: _phoneKey);
    await _storage.delete(key: _pointsKey);
  }

  // --- User Info ---
  Future<void> saveUserName(String name) async {
    await _storage.write(key: _nameKey, value: name);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _nameKey);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _roleKey);
  }

  Future<void> saveUserLGA(String lga) async {
    await _storage.write(key: _lgaKey, value: lga);
  }

  Future<String?> getUserLGA() async {
    return await _storage.read(key: _lgaKey);
  }

  Future<void> saveUserPhone(String phone) async {
    await _storage.write(key: _phoneKey, value: phone);
  }

  Future<String?> getUserPhone() async {
    return await _storage.read(key: _phoneKey);
  }

  // --- User Points ---
  Future<void> saveUserPoints(int points) async {
    await _storage.write(key: _pointsKey, value: points.toString());
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
  
  Future<void> clearOnboarding() async {
    await _storage.delete(key: _onboardingKey);
  }
}