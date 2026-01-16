import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _themeKey = 'app_theme';

  static const String _fcmTokenKey = 'fcm_token';

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<void> saveTheme(String themeMode) async {
    await _secureStorage.write(key: _themeKey, value: themeMode);
  }

  Future<String?> getTheme() async {
    return await _secureStorage.read(key: _themeKey);
  }

  Future<void> saveFcmToken(String token) async {
    await _secureStorage.write(key: _fcmTokenKey, value: token);
  }

  Future<String?> getFcmToken() async {
    return await _secureStorage.read(key: _fcmTokenKey);
  }
}
