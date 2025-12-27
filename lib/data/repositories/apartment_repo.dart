import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';

class ApartmentRepo {
  final ApartmentApi _api;
  final SecureStorageService _storage;

  // Dependency Injection (DI) through the constructor
  ApartmentRepo(this._api, this._storage);

  /// Helper to securely retrieve the auth token and check its existence.
  Future<String> _getAuthToken() async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      // Throw an error that the UI can catch, forcing a re-login
      throw ApiException(
        'Authentication token is missing. Please log in again.',
      );
    }
    return authToken;
  }

  /// Fetches all apartments without any filters.
  Future<List<ApartmentModel>> getAllApartments() async {
    final authToken = await _getAuthToken();

    return _api.fetchApartments(authToken);
  }

  /// Fetches a list of apartments based on provided filter parameters.
  Future<List<ApartmentModel>> getFilteredApartments(
    Map<String, dynamic> filters,
  ) async {
    final authToken = await _getAuthToken();

    return _api.fetchApartments(authToken, filters: filters);
  }

  // Fetches the detailed information for a single apartment.
  Future<ApartmentModel> getApartmentDetails(int apartmentId) async {
    final authToken = await _getAuthToken();

    // Delegate the request to the ApartmentApi
    return _api.fetchApartmentDetails(authToken, apartmentId);
  }

  Future<List<GovernorateModel>> getGovernorates() async {
    final authToken = await _getAuthToken();

    return _api.fetchGovernorates(authToken);
  }

  Future<List<CityModel>> getCities(int governorateId) async {
    final token = await _getAuthToken();
    return _api.fetchCities(token, governorateId);
  }

  /// Fetches all cities (no governorate filter)
  Future<List<CityModel>> getAllCities() async {
    final authToken = await _getAuthToken();
    return _api.fetchAllCities(authToken);
  }

  Future<List<ApartmentModel>> getFavoriteApartments() async {
    final authToken = await _getAuthToken();

    return _api.fetchFavorites(authToken);
  }

  Future<String> addToFavorites(int apartmentId) async {
    final authToken = await _getAuthToken();
    return _api.addFavorite(authToken, apartmentId);
  }

  Future<String> removeFromFavorites(int apartmentId) async {
    final authToken = await _getAuthToken();
    return _api.removeFavorite(authToken, apartmentId);
  }
}
