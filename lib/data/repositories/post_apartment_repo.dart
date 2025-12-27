import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/web_services/post_apartment_api.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

class PostApartmentRepo {
  final PostApartmentApi _api;
  final SecureStorageService _storage;

  PostApartmentRepo(this._api, this._storage);

  Future<String> _getAuthToken() async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      throw ApiException(
        'Authentication token is missing. Please log in again.',
      );
    }
    return authToken;
  }

  Future<dynamic> createApartment(PostApartmentModel apartment) async {
    final authToken = await _getAuthToken();

    final response = await _api.createApartment(apartment, authToken);

    if (response is Map<String, dynamic>) {
      if (response.containsKey('message')) {
        // Return the success message from your 200 OK response
        return response['message'] as String;
      }
      // Return the validation errors map if the status was 422
      return response;
    }

    // Return general error strings directly (like "Session expired" or "Server error")
    return response;
  }
}
