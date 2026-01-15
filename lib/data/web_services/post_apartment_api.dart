import 'package:dio/dio.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';
import 'package:pluto_ui/data/web_services/dio_factory.dart';

class PostApartmentApi {
  final Dio _dio = DioFactory.getDio();

  static final PostApartmentApi _instance = PostApartmentApi._internal();
  factory PostApartmentApi() => _instance;
  PostApartmentApi._internal();

  /// Creates FormData for the apartment request, including the photo file
  Future<FormData> _createFormData(PostApartmentModel apartment) async {
    final Map<String, dynamic> fields = {
      'city_id': apartment.cityId,
      'area': apartment.area,
      'rooms': apartment.rooms,
      'description': apartment.description,
      'price': apartment.price,
      'floor': apartment.floor,
    };

    // Process the photo path into a MultipartFile
    if (apartment.photo.isNotEmpty) {
      fields['photo'] = await MultipartFile.fromFile(
        apartment.photo,
        filename: apartment.photo.split('/').last,
      );
    }

    return FormData.fromMap(fields);
  }

  /// Sends the POST request to create a new apartment
  Future<dynamic> createApartment(
    PostApartmentModel apartment,
    String token,
  ) async {
    try {
      final formData = await _createFormData(apartment);

      Response response = await _dio.post(
        'apartments',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Handle Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' Apartment created successfully.');
        return response.data;
      }
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 422) {
        print(' Validation Error : $responseData');
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          return responseData['errors'] as Map<String, dynamic>;
        }
        return {
          "general": ["unvalid data"],
        };
      } else if (statusCode != null && statusCode >= 500) {
        return "server error, try again later";
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return "connectionError, check your connection";
      } else {
        return "unexpected error occurred $statusCode).";
      }
    } catch (e) {
      print('🔥 General Exception: ${e.toString()}');
      if (e.toString().contains('File')) {
        return "error in reading photo file";
      }
      return " unknow error while processing";
    }
  }
}
