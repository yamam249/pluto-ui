import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/models/login_request_model.dart';
import 'package:pluto_ui/data/models/login_response_model.dart';
// import the  ValidationException class
import 'package:pluto_ui/data/web_services/login_api.dart'
    show LoginApi, ApiException, ValidationException;

class LoginAuthRepo {
  final LoginApi loginApi;
  final SecureStorageService secureStorageService;

  // Constructor with dependency injection for both API and Storage
  LoginAuthRepo(this.loginApi, this.secureStorageService);

  // Function to handle the entire login process
  Future<void> loginUser(String phone, String password) async {
    try {
      // 1. Prepare Request Model
      final requestModel = LoginRequestModel(phone: phone, password: password);

      // 2. Call the API (Web Services Layer)
      final LoginResponseModel response = await loginApi.loginUser(
        requestModel,
      );

      // 3. Save the Token Securely (Storage Layer)
      await secureStorageService.saveToken(response.token);

      // If all steps succeed, the function completes successfully (void return)
      print('✅ تم تسجيل الدخول وحفظ التوكن في الريبو');

      //  Catch ValidationException (422) and rethrow it
    } on ValidationException {
      print('⚠️ تم إرسال خطأ التحقق (422) إلى طبقة الكيوبت.');
      rethrow;
    } on ApiException {
      // Re-throw general API errors (401, 5xx, etc.) back to the Business Logic
      print('⚠️ تم إرسال خطأ عام في API إلى طبقة الكيوبت.');
      rethrow;
    } catch (e) {
      // Catch any unexpected errors (e.g., storage failure)
      throw Exception(
        'حدث خطأ غير متوقع في عملية تسجيل الدخول: ${e.toString()}',
      );
    }
  }

  // Helper function to check login status, useful for app startup
  Future<String?> getAuthToken() async {
    return await secureStorageService.getToken();
  }

  // Helper function to log out
  Future<void> logout() async {
    return await secureStorageService.deleteToken();
  }
}
