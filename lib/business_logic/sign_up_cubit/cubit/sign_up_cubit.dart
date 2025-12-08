// File: lib/business_logic/sign_up_cubit/sign_up_cubit.dart

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
      print('Cubit: التسجيل نجح، إصدار حالة SignUpSuccess');
      emit(SignUpSuccess(result));

      // حالة خطأ التحقق
    } else if (result is Map<String, dynamic>) {
      print('Cubit: فشل التحقق (422)، إصدار حالة SignUpValidationError');
      emit(SignUpValidationError(result));

      // حالة الفشل العام (5xx أو خطأ شبكة)
    } else if (result is String) {
      print('Cubit: فشل عام/سيرفر، إصدار حالة SignUpFailure');
      // نمرر رسالة الخطأ التي أرجعتها طبقة الـ API/Repo
      emit(SignUpFailure(result));

      // حالة غير متوقعة
    } else {
      print('Cubit: خطأ غير معروف في نوع النتيجة');
      emit(SignUpFailure('حدث خطأ غير معروف في معالجة البيانات المرجعة.'));
    }
  }
}
