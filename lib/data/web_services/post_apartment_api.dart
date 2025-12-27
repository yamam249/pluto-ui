import 'package:dio/dio.dart';
import 'package:pluto_ui/constants/strings.dart';
import 'package:pluto_ui/data/models/post_apartment_model.dart';

class PostApartmentApi {
  late Dio dio;

  // 1. Static instance of the class
  static final PostApartmentApi _instance = PostApartmentApi._internal();

  // 2. Factory constructor that returns the singleton instance
  factory PostApartmentApi() {
    return _instance;
  }

  // 3. Private internal constructor for initialization
  PostApartmentApi._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    );
    dio = Dio(options);
  }

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

      Response response = await dio.post(
        'apartments',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Handle Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Apartment created successfully.');
        return response.data;
      }
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 422) {
        print('⚠️ Validation Error (422): $responseData');
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          return responseData['errors'] as Map<String, dynamic>;
        }
        return {
          "general": ["بيانات الإدخال غير صالحة."],
        };
      } else if (statusCode == 401) {
        return "انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى.";
      } else if (statusCode != null && statusCode >= 500) {
        return "حدثت مشكلة في السيرفر، يرجى المحاولة لاحقًا.";
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return "فشل الاتصال بالخادم، يرجى التحقق من الإنترنت.";
      } else {
        return "حدث خطأ غير متوقع (الرمز: $statusCode).";
      }
    } catch (e) {
      print('🔥 General Exception: ${e.toString()}');
      if (e.toString().contains('File')) {
        return "خطأ في قراءة ملف الصورة.";
      }
      return "حدث خطأ غير معروف أثناء إعداد الطلب.";
    }
  }
}
