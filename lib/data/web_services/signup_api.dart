// import 'package:dio/dio.dart';
// import 'package:pluto_ui/constants/strings.dart';
// import 'package:pluto_ui/data/models/signup_request_model.dart';
// import 'package:pluto_ui/data/models/signup_response_model.dart';

// class SignupApi {
//   late Dio dio;

//   SignupApi() {
//     BaseOptions options = BaseOptions(
//       baseUrl: baseUrl,
//       receiveDataWhenStatusError: true,
//       connectTimeout: const Duration(seconds: 60),
//       receiveTimeout: const Duration(seconds: 60),
//       headers: {'Accept': 'application/json'},
//     );
//     dio = Dio(options);
//   }

//   Future<FormData> _createFormData(SignupRequestModel user) async {
//     //  المكونات غير المتعلقة بالملفات
//     final Map<String, dynamic> fields = {
//       'phone': user.phone,
//       'first_name': user.firstName,
//       'last_name': user.lastName,
//       'password': user.password,
//       'birth_date': user.birthDate,
//     };

//     //  معالجة حقل صورة الهوية  - يتم إضافته فقط إذا كان المسار غير فارغ
//     if (user.idImagePath.isNotEmpty) {
//       fields['id_image'] = await MultipartFile.fromFile(
//         user.idImagePath,
//         filename: user.idImagePath.split('/').last,
//       );
//     }

//     //  معالجة حقل الصورة الشخصية  - يتم إضافته فقط إذا كان المسار غير فارغ
//     if (user.profileImagePath.isNotEmpty) {
//       fields['profile_image'] = await MultipartFile.fromFile(
//         user.profileImagePath,
//         filename: user.profileImagePath.split('/').last,
//       );
//     }

//     return FormData.fromMap(fields);
//   }

//   Future<dynamic> createNewUser(SignupRequestModel user) async {
//     try {
//       final formData = await _createFormData(user);

//       Response response = await dio.post('auth/register', data: formData);

//       // التعامل مع 201 Created (النجاح)
//       if (response.statusCode == 201) {
//         print('✅ تم إضافة المستخدم بنجاح.');
//         return SignupResponseModel.fromJson(response.data);
//       }
//       return response.data;
//     } on DioException catch (e) {
//       final statusCode = e.response?.statusCode;
//       final responseData = e.response?.data;

//       if (statusCode == 422) {
//         print('⚠️ خطأ في التحقق (422): ${responseData}');

//         if (responseData is Map<String, dynamic> &&
//             responseData.containsKey('errors')) {
//           // إرجاع الأخطاء المفصلة إلى Cubit
//           return responseData['errors'] as Map<String, dynamic>;
//         }

//         return {
//               "general": ["بيانات الإدخال غير صالحة. يرجى مراجعة الحقول."],
//             }
//             as Map<String, dynamic>;
//       } else if (statusCode != null && statusCode >= 500) {
//         print('❌ خطأ في السيرفر ($statusCode): ${e.message}');
//         return "حدثت مشكلة في السيرفر، يرجى المحاولة لاحقًا.";

//         // معالجة أخطاء الشبكة والمهلة
//       } else if (e.type == DioExceptionType.connectionTimeout ||
//           e.type == DioExceptionType.sendTimeout ||
//           e.type == DioExceptionType.receiveTimeout ||
//           e.type == DioExceptionType.connectionError) {
//         print('⏳ فشل الاتصال: ${e.message}');
//         return "فشل الاتصال بالخادم، يرجى التحقق من اتصال الإنترنت.";

//         //  أي خطأ آخر (مثل 401, 403, 404)
//       } else {
//         print('❓ خطأ آخر غير متوقع: ${e.message}');
//         return "حدث خطأ أثناء معالجة الطلب (الرمز: $statusCode).";
//       }
//     } catch (e) {
//       // 💡 التعامل مع أي استثناءات أخرى (مثل فشل قراءة الملفات المحلية)
//       print('🔥 خطأ عام: ${e.toString()}');

//       // رسالة توضيحية لخطأ الملفات
//       if (e.toString().contains('File') || e.toString().contains('path')) {
//         return "خطأ في قراءة ملف الصورة، يرجى إعادة اختيارها.";
//       }

//       return "حدث خطأ غير معروف أثناء إعداد الطلب.";
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:pluto_ui/data/models/signup_request_model.dart';
import 'package:pluto_ui/data/models/signup_response_model.dart';
import 'package:pluto_ui/data/web_services/dio_factory.dart';
import 'package:pluto_ui/data/web_services/login_api.dart';

class SignupApi {
  final Dio _dio = DioFactory.getDio();

  Future<FormData> _createFormData(SignupRequestModel user) async {
    final Map<String, dynamic> fields = {
      'phone': user.phone,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'password': user.password,
      'birth_date': user.birthDate,
    };

    if (user.idImagePath.isNotEmpty) {
      fields['id_image'] = await MultipartFile.fromFile(
        user.idImagePath,
        filename: user.idImagePath.split('/').last,
      );
    }

    if (user.profileImagePath.isNotEmpty) {
      fields['profile_image'] = await MultipartFile.fromFile(
        user.profileImagePath,
        filename: user.profileImagePath.split('/').last,
      );
    }

    return FormData.fromMap(fields);
  }

  Future<dynamic> createNewUser(SignupRequestModel user) async {
    try {
      final formData = await _createFormData(user);
      Response response = await _dio.post('auth/register', data: formData);

      if (response.statusCode == 201) {
        return SignupResponseModel.fromJson(response.data);
      }
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 422) {
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          return responseData['errors'] as Map<String, dynamic>;
        }
      }

      // Map other errors to a simple message or rethrow
      throw ApiException(responseData?['message'] ?? "حدث خطأ أثناء التسجيل.");
    }
  }
}
