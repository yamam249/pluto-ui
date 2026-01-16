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
      final fcmToken = await secureStorageService.getFcmToken();
      final requestModel = LoginRequestModel(
        phone: phone,
        password: password,
        fcmToken: fcmToken,
      );

      final LoginResponseModel response = await loginApi.loginUser(
        requestModel,
      );

      await secureStorageService.saveToken(response.token);

      print('log in was made and saving token');
    } on ValidationException {
      print('repo: validation errors');
      rethrow;
    } on ApiException {
      print("repo: general error");
      rethrow;
    } catch (e) {
      throw Exception("repo: unexpected error occured: ${e.toString()}");
    }
  }

  Future<String?> getAuthToken() async {
    return await secureStorageService.getToken();
  }

  Future<void> logoutUser() async {
    try {
      final token = await secureStorageService.getToken();

      if (token != null) {
        await loginApi.logout(token);
      }
    } on ApiException catch (e) {
      print(
        'Repo: Server logout failed, but proceeding to clear local storage: ${e.message}',
      );
    } finally {
      await secureStorageService.deleteToken();
      print(' Repo: Local token deleted.');
    }
  }
}
