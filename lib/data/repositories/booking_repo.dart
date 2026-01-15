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

  BookingRepo(this._api, this._storage);

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

  Future<String> createBooking(CreateBookingModel bookingData) async {
    final authToken = await _getAuthToken();

    return _api.createBooking(authToken, bookingData);
  }

  Future<List<HistoryModel>> getBookingHistory() async {
    final authToken = await _getAuthToken();

    return _api.fetchHistory(authToken);
  }

  Future<String> cancelBooking(int bookingId) async {
    final token = await _getAuthToken();
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
