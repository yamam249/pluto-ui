import 'package:dio/dio.dart';
import 'package:pluto_ui/data/models/profile_model.dart';
import 'package:pluto_ui/data/web_services/dio_factory.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;

class ProfileApi {
  static const String _endpoint = '/user/profile';
  final Dio _dio = DioFactory.getDio();

  static final ProfileApi _singleton = ProfileApi._internal();
  ProfileApi._internal();
  factory ProfileApi() => _singleton;

  // --- Consistent Error Handling ---
  void _handleDioError(DioException e) {
    print('❌ PROFILE DIO EXCEPTION: ${e.response?.statusCode ?? e.type}');

    if (e.response?.statusCode == 500) {
      throw ApiException('Server error (500). Please try again later.');
    }
    if (e.type == DioExceptionType.connectionTimeout) {
      throw ApiException('Connection timed out.');
    }

    final errorMessage =
        e.response?.data?['message'] ?? 'Failed to load profile.';
    throw ApiException(errorMessage);
  }

  /// Fetches the authenticated user's profile information
  Future<ProfileModel> fetchUserProfile(String authToken) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get(_endpoint, options: options);

      print('✅ PROFILE RESPONSE STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        // Validation: Ensure response is a Map and contains 'data'
        if (responsePayload is! Map<String, dynamic>) {
          throw ApiException('Unexpected response format.');
        }

        final dynamic rawData = responsePayload['data'];

        if (rawData is! Map<String, dynamic>) {
          throw ApiException('Profile data is missing or invalid.');
        }

        return ProfileModel.fromJson(rawData);
      }

      throw ApiException('Could not retrieve profile info.');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print('💥 GENERAL EXCEPTION: ${e.toString()}');
      throw ApiException('An unexpected error occurred.');
    }
  }
}
