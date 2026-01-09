import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/data/models/login_request_model.dart';
import 'package:pluto_ui/data/models/login_response_model.dart';
import 'package:pluto_ui/data/web_services/login_api.dart'
    show LoginApi, ApiException, ValidationException;

class LoginAuthRepo {
  final LoginApi loginApi;
  final SecureStorageService secureStorageService;

  LoginAuthRepo(this.loginApi, this.secureStorageService);

  Future<void> loginUser(String phone, String password) async {
    try {
      final requestModel = LoginRequestModel(phone: phone, password: password);

      final LoginResponseModel response = await loginApi.loginUser(
        requestModel,
      );

      await secureStorageService.saveToken(response.token);

      print('✅ تم تسجيل الدخول وحفظ التوكن في الريبو');

    } on ValidationException {
      print('⚠️ تم إرسال خطأ التحقق (422) إلى طبقة الكيوبت.');
      rethrow;
    } on ApiException {
      print('⚠️ تم إرسال خطأ عام في API إلى طبقة الكيوبت.');
      rethrow;
    } catch (e) {
      throw Exception(
        'حدث خطأ غير متوقع في عملية تسجيل الدخول: ${e.toString()}',
      );
    }
  }

  // Helper function to check login status, useful for app startup
  Future<String?> getAuthToken() async {
    return await secureStorageService.getToken();
  }


  Future<void> logoutUser() async {
    try {
      final token = await secureStorageService.getToken();

      if (token != null) {
        //  Inform the server to revoke the token
        await loginApi.logout(token);
      }
    } on ApiException catch (e) {
      print(
        'Repo: Server logout failed, but proceeding to clear local storage: ${e.message}',
      );
    } finally {
      //  Always delete the token locally to ensure the user is "logged out" in the UI
      await secureStorageService.deleteToken();
      print('✅ Repo: Local token deleted.');
    }
  }
}
