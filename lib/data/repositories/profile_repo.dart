import 'package:pluto_ui/data/models/profile_model.dart';
import 'package:pluto_ui/data/web_services/profile_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/main.dart';

class ProfileRepo {
  final ProfileApi _api;
  final SecureStorageService _storage;

  // Dependency Injection (DI) through the constructor
  ProfileRepo(this._api, this._storage);

  /// Helper to securely retrieve the auth token and check its existence.
  /// Matches the pattern used in ApartmentRepo for consistency.
  // Future<String> _getAuthToken() async {
  //   final authToken = await _storage.getToken();
  //   if (authToken == null || authToken.isEmpty) {
  //     throw ApiException(
  //       'Authentication token is missing. Please log in again.',
  //     );
  //   }
  //   return authToken;
  // }
  Future<String> _getAuthToken() async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      // 1. Silent Navigation: Kick them to login immediately
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );

      // 2. Throw a specific "Silent" exception that the UI logic will ignore
      throw ApiException('auth-ignore');
    }
    return authToken;
  }

  /// Fetches the authenticated user's profile details.
  Future<ProfileModel> getUserProfile() async {
    final authToken = await _getAuthToken();

    // Delegate the request to the ProfileApi
    return _api.fetchUserProfile(authToken);
  }
}
