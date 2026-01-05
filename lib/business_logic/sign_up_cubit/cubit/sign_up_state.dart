part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final SignupResponseModel responseModel;
  SignUpSuccess(this.responseModel);
}

final class SignUpValidationError extends SignUpState {
  final Map<String, dynamic> errors;
  SignUpValidationError(this.errors);
}

final class SignUpFailure extends SignUpState {
  final String errorMessage;
  SignUpFailure(this.errorMessage);
}
