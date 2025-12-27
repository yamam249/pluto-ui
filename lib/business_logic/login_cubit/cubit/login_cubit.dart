import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pluto_ui/data/repositories/login_auth_repo.dart';
import 'package:pluto_ui/data/web_services/login_api.dart'
    show ApiException, ValidationException;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginAuthRepo loginAuthRepo;

  LoginCubit(this.loginAuthRepo) : super(LoginInitial());

  Future<void> loginUser(String phone, String password) async {
    emit(LoginLoading());

    try {
      await loginAuthRepo.loginUser(phone, password);

      // If the function completes without throwing, it was a success!
      print('Cubit: تسجيل الدخول وحفظ التوكن نجح، إصدار حالة LoginSuccess');
      emit(LoginSuccess());
    } on ValidationException catch (e) {
      print('Cubit: خطأ في التحقق (422)، إصدار حالة LoginValidationError');
      emit(LoginValidationError(e.errors)); // Pass the error map to the state
    } on ApiException catch (e) {
      // Handles 401, 5xx, and network errors thrown by the API layer
      print('Cubit: فشل API/عام، إصدار حالة LoginFailure');
      emit(LoginFailure(e.message));
    } catch (e) {
      // Handles unexpected errors (like a token storage failure)
      print('Cubit: فشل غير متوقع، إصدار حالة LoginFailure');
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await loginAuthRepo.getAuthToken();
    emit(AuthStatusChecked(token != null));
  }

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await loginAuthRepo.logoutUser();
      print('Cubit: Logout successful, emitting LogoutSuccess');
      emit(LogoutSuccess());
    } catch (e) {
      print('Cubit: Logout error');
      emit(LogoutFailure(e.toString()));
    }
  }
}
