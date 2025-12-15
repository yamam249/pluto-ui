import 'package:dio/dio.dart';
import 'package:pluto_ui/constants/strings.dart';
import 'package:pluto_ui/data/models/login_request_model.dart';
import 'package:pluto_ui/data/models/login_response_model.dart';

// 1. ADD: Exception to carry the field-specific errors (422)
class ValidationException implements Exception {
  final Map<String, List<String>> errors;

  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}

// You will need this exception class for the service layer
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

class LoginApi {
  late Dio dio;

  LoginApi() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      // Set 'Content-Type' to 'application/json' for a standard login
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    dio = Dio(options);
  }

  // This function returns the LoginResponseModel (containing the token) on success.
  Future<LoginResponseModel> loginUser(LoginRequestModel user) async {
    try {
      // Prepare the JSON body using the model's toJson()
      final body = user.toJson();

      Response response = await dio.post('auth/login', data: body);

      //
      if (response.statusCode == 200) {
        print('✅ تسجيل الدخول ناجح.');
        // Return the strong-typed response model
        return LoginResponseModel.fromJson(response.data);
      }

      // If we reach here, something unexpected happened but the response was non-DioException.
      throw ApiException("حدث خطأ غير متوقع بعد إرسال البيانات.");
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      // --- Handle Specific Login Errors ---

      if (statusCode == 401) {
        // 401 Unauthorized: "Invalid phone or password."
        final message = responseData is Map<String, dynamic>
            ? responseData['message'] as String?
            : 'رقم الهاتف أو كلمة المرور غير صحيحة.';

        print('⚠️ خطأ في المصادقة (401): $message');
        throw ApiException(message ?? 'خطأ في المصادقة (401).');
      } else if (statusCode == 422) {
        // 4. MODIFIED: Handle 422 Validation Error by throwing ValidationException
        print('⚠️ خطأ في التحقق (422): ${responseData}');

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          final Map<String, dynamic> errorsData = responseData['errors'];

          // Convert the dynamic map to the required Map<String, List<String>>
          final Map<String, List<String>> formattedErrors = errorsData.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          );

          // Throw the new exception containing the full map
          throw ValidationException(formattedErrors);
        }

        // If 'errors' key is missing, throw a general error
        throw ApiException(
          responseData?['message'] ?? "بيانات الإدخال غير صالحة.",
        );

        // --- Handle General Errors ---
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        // Network/Timeout Errors
        print('⏳ فشل الاتصال: ${e.message}');
        throw ApiException(
          "فشل الاتصال بالخادم، يرجى التحقق من اتصال الإنترنت.",
        );
      } else if (statusCode != null && statusCode >= 500) {
        // Server Errors
        print('❌ خطأ في السيرفر ($statusCode): ${e.message}');
        throw ApiException("حدثت مشكلة في السيرفر، يرجى المحاولة لاحقًا.");
      } else {
        // Any Other Error (e.g., 404 Not Found, 403 Forbidden)
        print('❓ خطأ آخر غير متوقع: ${e.message}');
        throw ApiException("حدث خطأ أثناء معالجة الطلب (الرمز: $statusCode).");
      }
    } catch (e) {
      // Catch any non-Dio exceptions (e.g., model parsing error)
      print('🔥 خطأ عام: ${e.toString()}');
      throw ApiException("حدث خطأ غير معروف.");
    }
  }
}
