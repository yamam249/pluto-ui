import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Define the key for the token
  static const String _tokenKey = 'auth_token';
  static const String _themeKey = 'app_theme';
  // String _getThemeKey(String userId) => 'theme_pref_$userId';
  // 1. Write the token securely
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // 2. Read the token securely
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // 3. Delete the token (for logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // 4. Save Theme Preference
  Future<void> saveTheme(String themeMode) async {
    await _secureStorage.write(key: _themeKey, value: themeMode);
  }

  // // 4. Save Theme for a specific user
  // Future<void> saveUserTheme(String userId, String themeMode) async {
  //   await _secureStorage.write(key: _getThemeKey(userId), value: themeMode);
  // }

  // 5. Get Saved Theme Preference
  Future<String?> getTheme() async {
    return await _secureStorage.read(key: _themeKey);
  }

  // // 5. Read Theme for a specific user
  // Future<String?> getUserTheme(String userId) async {
  //   return await _secureStorage.read(key: _getThemeKey(userId));
  // }
}
