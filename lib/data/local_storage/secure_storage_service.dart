import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Define the key for the token
  static const String _tokenKey = 'auth_token';

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
}
