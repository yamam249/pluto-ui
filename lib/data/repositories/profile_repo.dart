import 'package:pluto_ui/data/models/profile_model.dart';
import 'package:pluto_ui/data/web_services/profile_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/main.dart';

class ProfileRepo {
  final ProfileApi _api;
  final SecureStorageService _storage;

  ProfileRepo(this._api, this._storage);

  Future<String> _getAuthToken() async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );

      throw ApiException('auth-ignore');
    }
    return authToken;
  }

  Future<ProfileModel> getUserProfile() async {
    final authToken = await _getAuthToken();

    return _api.fetchUserProfile(authToken);
  }
}
