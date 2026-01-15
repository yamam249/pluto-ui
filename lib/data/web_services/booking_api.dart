import 'package:dio/dio.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
import 'package:pluto_ui/data/models/history_model.dart';
import 'package:pluto_ui/data/models/registration_model.dart';
import 'package:pluto_ui/data/models/update_booking_request_model.dart';
import 'package:pluto_ui/data/models/update_registration_model.dart';
import 'package:pluto_ui/data/web_services/dio_factory.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';

class BookingApi {
  static const String _endpoint = '/bookings';
  final Dio _dio = DioFactory.getDio();
  BookingApi._internal();
  static final BookingApi _singleton = BookingApi._internal();
  factory BookingApi() => _singleton;

  // --- Helper Function for Consistent Error Handling ---
  void _handleDioError(DioException e) {
    print('❌ DIO EXCEPTION CAUGHT: ${e.response?.statusCode ?? e.type}');

    if (e.response?.statusCode == 500) {
      throw ApiException('Server Error (500). Please try again later.');
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw ApiException(
        'Network Timeout. Please check your internet connection.',
      );
    }

    // Default message from server or fallback
    final errorMessage =
        e.response?.data?['message'] ?? 'An unknown server error occurred.';
    throw ApiException(errorMessage);
  }

  // --- API Methods ---

  Future<String> createBooking(String token, CreateBookingModel booking) async {
    try {
      // Sending data as form-data per backend requirements
      final formData = FormData.fromMap(booking.toJson());

      Response response = await _dio.post(
        _endpoint,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['message'] ?? "Request added successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          final Map<String, dynamic> errorsData = responseData['errors'];
          final formattedErrors = errorsData.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          );
          throw ValidationException(formattedErrors);
        }
      }

      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      // Handle everything else via helper
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<List<HistoryModel>> fetchHistory(String token) async {
    try {
      Response response = await _dio.get(
        _endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic> ||
            responsePayload['data'] is! List) {
          throw ApiException('Invalid data format received from server.');
        }

        final List<dynamic> historyData = responsePayload['data'];

        return historyData
            .whereType<Map<String, dynamic>>()
            .map(HistoryModel.fromJson)
            .toList();
      }

      throw ApiException("Failed to load history");
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Inside BookingApi class

  Future<String> cancelBooking(String token, int bookingId) async {
    try {
      final response = await _dio.patch(
        '$_endpoint/$bookingId/cancel',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Canceled successfully.";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException("Booking not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<String> updateBooking(
    String token,
    int bookingId,
    UpdateBookingRequestModel requestData,
  ) async {
    try {
      Response response = await _dio.put(
        '$_endpoint/$bookingId/update',
        data: requestData.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Request added successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          final Map<String, dynamic> errorsData = responseData['errors'];
          final formattedErrors = errorsData.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          );
          // Throwing specific validation exception to be caught by Cubit
          throw ValidationException(formattedErrors);
        }
      }
      // Handle specific status codes from your Laravel controller
      if (e.response?.statusCode == 402) {
        // NotEnoughBalanceException
        throw ApiException(
          e.response?.data['message'] ?? "Insufficient balance.",
        );
      }
      if (e.response?.statusCode == 400) {
        // DomainException
        throw ApiException(
          e.response?.data['message'] ?? "Invalid update request.",
        );
      }

      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }

      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<List<RegistrationModel>> fetchRegistrations(String token) async {
    try {
      Response response = await _dio.get(
        '$_endpoint/registrations', // Resulting in /bookings/registrations
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic> ||
            responsePayload['data'] is! List) {
          throw ApiException('Invalid data format received from server.');
        }

        final List<dynamic> registrationData = responsePayload['data'];

        return registrationData
            .whereType<Map<String, dynamic>>()
            .map(RegistrationModel.fromJson)
            .toList();
      }

      throw ApiException("Failed to load registration requests.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<String> acceptBooking(String token, int bookingId) async {
    try {
      Response response = await _dio.patch(
        '$_endpoint/$bookingId/accept',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Accepted successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      // Handling the DomainException (400) thrown by your Laravel backend
      if (e.response?.statusCode == 400) {
        throw ApiException(
          e.response?.data['message'] ?? "Could not accept booking.",
        );
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Inside BookingApi class

  Future<String> declineBooking(String token, int bookingId) async {
    try {
      Response response = await _dio.patch(
        '$_endpoint/$bookingId/decline',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Declined successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      // Handling the DomainException (400) from your Laravel backend
      if (e.response?.statusCode == 400) {
        throw ApiException(
          e.response?.data['message'] ?? "Could not decline booking.",
        );
      }

      if (e.response?.statusCode == 404) {
        throw ApiException("Booking not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<List<UpdateRegistrationModel>> fetchUpdateRequests(
    String token,
  ) async {
    try {
      Response response = await _dio.get(
        '$_endpoint/updateRequests', // Results in /bookings/updateRequests
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic> ||
            responsePayload['data'] is! List) {
          throw ApiException('Invalid data format received from server.');
        }

        final List<dynamic> listData = responsePayload['data'];

        return listData
            .whereType<Map<String, dynamic>>()
            .map(UpdateRegistrationModel.fromJson)
            .toList();
      }

      throw ApiException("Failed to load update requests.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<String> acceptUpdateRequest(String token, int requestId) async {
    try {
      Response response = await _dio.put(
        '$_endpoint/updateRequests/$requestId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Accepted successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ApiException(
          e.response?.data['message'] ?? "Could not accept update request.",
        );
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<String> deleteUpdateRequest(String token, int requestId) async {
    try {
      Response response = await _dio.delete(
        '$_endpoint/updateRequests/$requestId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "deleted successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ApiException("You are not authorized to delete this request.");
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }
}
