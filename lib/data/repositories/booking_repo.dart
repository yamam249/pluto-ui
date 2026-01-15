import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
import 'package:pluto_ui/data/models/history_model.dart';
import 'package:pluto_ui/data/models/registration_model.dart';
import 'package:pluto_ui/data/models/update_booking_request_model.dart';
import 'package:pluto_ui/data/models/update_registration_model.dart';
import 'package:pluto_ui/data/web_services/booking_api.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import 'package:pluto_ui/main.dart';

class BookingRepo {
  final BookingApi _api;
  final SecureStorageService _storage;

  // Dependency Injection (DI) through the constructor
  BookingRepo(this._api, this._storage);

  /// Helper to securely retrieve the auth token and check its existence.
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

  /// Handles the creation of a new booking request.
  Future<String> createBooking(CreateBookingModel bookingData) async {
    final authToken = await _getAuthToken();

    // Delegate the request to the BookingApi
    return _api.createBooking(authToken, bookingData);
  }

  /// Fetches the list of user bookings (History).
  Future<List<HistoryModel>> getBookingHistory() async {
    final authToken = await _getAuthToken();

    // Delegate the request to the BookingApi and return the list of models
    return _api.fetchHistory(authToken);
  }

  Future<String> cancelBooking(int bookingId) async {
    final token = await _getAuthToken(); // Use your existing token helper
    return _api.cancelBooking(token, bookingId);
  }

  Future<String> updateBooking(
    int bookingId,
    UpdateBookingRequestModel requestData,
  ) async {
    final authToken = await _getAuthToken();

    return _api.updateBooking(authToken, bookingId, requestData);
  }

  Future<List<RegistrationModel>> getRegistrations() async {
    final authToken = await _getAuthToken();

    return _api.fetchRegistrations(authToken);
  }

  Future<String> acceptBooking(int bookingId) async {
    final authToken = await _getAuthToken();
    return _api.acceptBooking(authToken, bookingId);
  }

  Future<String> declineBooking(int bookingId) async {
    final authToken = await _getAuthToken();
    return _api.declineBooking(authToken, bookingId);
  }

  Future<List<UpdateRegistrationModel>> getUpdateRequests() async {
    final authToken = await _getAuthToken();
    return _api.fetchUpdateRequests(authToken);
  }

  Future<String> acceptUpdate(int requestId) async {
    final authToken = await _getAuthToken();
    return _api.acceptUpdateRequest(authToken, requestId);
  }

  Future<String> deleteUpdate(int requestId) async {
    final authToken = await _getAuthToken();
    return _api.deleteUpdateRequest(authToken, requestId);
  }
}
