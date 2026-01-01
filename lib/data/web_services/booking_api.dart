import 'package:dio/dio.dart';
import 'package:pluto_ui/constants/strings.dart';
import 'package:pluto_ui/data/models/create_booking_model.dart';
// Importing your existing exceptions
import 'package:pluto_ui/data/web_services/login_api.dart';

class BookingApi {
  late Dio _dio;

  BookingApi._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    );
    _dio = Dio(options);
  }

  static final BookingApi _singleton = BookingApi._internal();
  factory BookingApi() => _singleton;

  Future<String> createBooking(String token, CreateBookingModel booking) async {
    try {
      // Sending data as form-data per your Postman screenshot
      final formData = FormData.fromMap(booking.toJson());

      Response response = await _dio.post(
        'bookings',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['message'] ?? "Request added successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      // --- Handle Status Codes ---

      if (statusCode == 422) {
        // Validation Error: Throws ValidationException with the map of errors
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          final Map<String, dynamic> errorsData = responseData['errors'];
          final formattedErrors = errorsData.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          );
          throw ValidationException(formattedErrors);
        }
      }

      if (statusCode == 409 || statusCode == 402) {
        // Conflict or Payment Required
        final message = responseData is Map<String, dynamic>
            ? responseData['message']
            : "Operation failed";
        throw ApiException(message);
      }

      // Handle General Network Errors using your pattern
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw ApiException("Connection failed, check your internet.");
      } else if (statusCode != null && statusCode >= 500) {
        throw ApiException("Server error, please try again later.");
      } else {
        throw ApiException(
          responseData?['message'] ?? "An error occurred ($statusCode)",
        );
      }
    } catch (e) {
      throw ApiException("An unexpected error occurred.");
    }
  }
}
