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

      print('Cubit: LoginSuccess');
      emit(LoginSuccess());
    } on ValidationException catch (e) {
      print('Cubit: LoginValidationError');
      emit(LoginValidationError(e.errors));
    } on ApiException catch (e) {
      print('Cubit: LoginFailure');
      emit(LoginFailure(e.message));
    } catch (e) {
      print('Cubit: LoginFailure');
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await loginAuthRepo.getAuthToken();
    emit(AuthStatusChecked(token != null));
  }

  Future<bool> isUserLoggedIn() async {
    final token = await loginAuthRepo.getAuthToken();
    return token != null;
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
