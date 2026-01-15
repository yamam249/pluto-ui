import 'package:dio/dio.dart';
import 'package:pluto_ui/data/models/login_request_model.dart';
import 'package:pluto_ui/data/models/login_response_model.dart';
import 'package:pluto_ui/data/web_services/dio_factory.dart';

class ValidationException implements Exception {
  final Map<String, List<String>> errors;

  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

class LoginApi {
  final Dio _dio = DioFactory.getDio();

  Future<LoginResponseModel> loginUser(LoginRequestModel user) async {
    try {
      Response response = await _dio.post('auth/login', data: user.toJson());

      if (response.statusCode == 200) {
        print(' Login Successful');
        return LoginResponseModel.fromJson(response.data);
      }
      throw ApiException("Unexpected error occurred.");
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 401) {
        throw ApiException(
          responseData?['message'] ?? "phone number or password is not correct",
        );
      } else if (statusCode == 422) {
        _handleValidationException(e);
      }

      throw ApiException(responseData?['message'] ?? "server connection error");
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post(
        'auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      print(' API Logout Error: $e');
    }
  }

  void _handleValidationException(DioException e) {
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
}
