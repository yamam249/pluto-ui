import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
import 'package:pluto_ui/data/web_services/booking_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

class BookingRepo {
  final BookingApi _api;
  final SecureStorageService _storage;

  // Dependency Injection (DI) through the constructor
  BookingRepo(this._api, this._storage);

  /// Helper to securely retrieve the auth token and check its existence.
  Future<String> _getAuthToken() async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      throw ApiException(
        'Authentication token is missing. Please log in again.',
      );
    }
    return authToken;
  }

  /// Handles the creation of a new booking request.
  Future<String> createBooking(CreateBookingModel bookingData) async {
    final authToken = await _getAuthToken();

    // Delegate the request to the BookingApi
    return _api.createBooking(authToken, bookingData);
  }
}
