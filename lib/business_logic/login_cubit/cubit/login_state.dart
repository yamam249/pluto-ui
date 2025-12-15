part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginValidationError extends LoginState {
  final Map<String, List<String>> errors;

  LoginValidationError(this.errors);
}

final class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}

// A state to signal the initial authentication check result
final class AuthStatusChecked extends LoginState {
  final bool isLoggedIn;
  AuthStatusChecked(this.isLoggedIn);
}
