import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pluto_ui/data/models/signup_request_model.dart';
import 'package:pluto_ui/data/models/signup_response_model.dart';
import 'package:pluto_ui/data/repositories/signup_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignupRepo signupRepo;

  SignUpCubit(this.signupRepo) : super(SignUpInitial());

  Future<void> createNewUser(SignupRequestModel user) async {
    emit(SignUpLoading());

    final result = await signupRepo.createNewUser(user);

    if (result is SignupResponseModel) {
      print('Cubit: SignUpSuccess');
      emit(SignUpSuccess(result));
    } else if (result is Map<String, dynamic>) {
      print('Cubit: SignUpValidationError');
      emit(SignUpValidationError(result));
    } else if (result is String) {
      print('Cubit: فشل عام/سيرفر، إصدار حالة SignUpFailure');
      emit(SignUpFailure(result));
    } else {
      print('Cubit: unknow error occurred');
      emit(SignUpFailure('unknow error occurred while processing'));
    }
  }
}
