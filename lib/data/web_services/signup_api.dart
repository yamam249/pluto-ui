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
      throw ApiException(
        responseData?['message'] ?? "error while registration",
      );
    }
  }
}
