import 'package:pluto_ui/data/models/apartment_model.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/web_services/apartment_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/main.dart';

class ApartmentRepo {
  final ApartmentApi _api;
  final SecureStorageService _storage;

  ApartmentRepo(this._api, this._storage);

  Future<String> _getAuthToken() async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      //  Silent Navigation
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );

      throw ApiException('auth-ignore');
    }
    return authToken;
  }

  Future<List<ApartmentModel>> getAllApartments() async {
    final authToken = await _getAuthToken();

    return _api.fetchApartments(authToken);
  }

  Future<List<ApartmentModel>> getFilteredApartments(
    Map<String, dynamic> filters,
  ) async {
    final authToken = await _getAuthToken();

    return _api.fetchApartments(authToken, filters: filters);
  }

  Future<ApartmentModel> getApartmentDetails(int apartmentId) async {
    final authToken = await _getAuthToken();

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

  Future<String> rateApartment(int apartmentId, double rating) async {
    final authToken = await _getAuthToken();

    return _api.rateApartment(authToken, apartmentId, rating);
  }
}
