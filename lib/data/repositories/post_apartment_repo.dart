import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/web_services/post_apartment_api.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import 'package:pluto_ui/main.dart';

class PostApartmentRepo {
  final PostApartmentApi _api;
  final SecureStorageService _storage;

  PostApartmentRepo(this._api, this._storage);

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

  Future<dynamic> createApartment(PostApartmentModel apartment) async {
    final authToken = await _getAuthToken();

    final response = await _api.createApartment(apartment, authToken);

    if (response is Map<String, dynamic>) {
      if (response.containsKey('message')) {
        return response['message'] as String;
      }
      return response;
    }

    return response;
  }
}
