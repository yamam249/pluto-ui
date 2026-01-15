import 'package:dio/dio.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/web_services/dio_factory.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import '../models/apartment_model.dart';

class ApartmentApi {
  static const String _endpoint = '/apartments';
  final Dio _dio = DioFactory.getDio();

  ApartmentApi._internal();
  static final ApartmentApi _singleton = ApartmentApi._internal();
  factory ApartmentApi() => _singleton;

  void _handleDioError(DioException e) {
    print(' DIO EXCEPTION CAUGHT: ${e.response?.statusCode ?? e.type}');
    print(' DIO EXCEPTION DATA: ${e.response?.data}');

    if (e.response?.statusCode == 500) {
      throw ApiException(
        'Internal Server Error (500). Check the backend logs for details.',
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException('Network Timeout. Please check your connection.');
    }

    final errorMessage =
        e.response?.data?['message'] ?? 'An unknown server error occurred.';
    throw ApiException(errorMessage);
  }

  Future<List<ApartmentModel>> fetchApartments(
    String authToken, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get(
        _endpoint,
        queryParameters: filters,
        options: options,
      );
      print(' RAW DIO RESPONSE STATUS: ${response.statusCode}');
      print(' RAW DIO RESPONSE DATA: ${response.data}');
      if (response.statusCode == 200) {
        print(' RAW API SUCCESS RESPONSE: ${response.data}');

        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic>) {
          throw ApiException(
            'API response root is not a Map: ${response.data.toString()}',
          );
        }

        final dynamic rawData = responsePayload['data'];
        if (rawData is! List) {
          throw ApiException('Invalid data format received from server.');
        }

        final List<dynamic> apartmentData = rawData;

        return apartmentData
            .whereType<Map<String, dynamic>>()
            .map(ApartmentModel.fromJson)
            .toList();
      }

      throw ApiException(
        'Failed to fetch apartments with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print(' GENERAL EXCEPTION CAUGHT: ${e.toString()}');

      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApartmentModel> fetchApartmentDetails(
    String authToken,
    int apartmentId,
  ) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get(
        '$_endpoint/$apartmentId',
        options: options,
      );

      print('DETAIL RAW DIO RESPONSE STATUS: ${response.statusCode}');
      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic>) {
          throw ApiException('API response root is not a Map.');
        }

        final dynamic rawData = responsePayload['data'];

        if (rawData is! Map<String, dynamic>) {
          throw ApiException(
            'Invalid data format received from server (expected object).',
          );
        }

        return ApartmentModel.fromJson(rawData);
      }

      throw ApiException(
        'Failed to fetch apartment details with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print(' GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<GovernorateModel>> fetchGovernorates(String authToken) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get('/governorates', options: options);

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is Map<String, dynamic> &&
            responsePayload['data'] is List) {
          final List<dynamic> data = responsePayload['data'];

          return data
              .whereType<Map<String, dynamic>>()
              .map(GovernorateModel.fromJson)
              .toList();
        }

        throw ApiException('Invalid data format received for governorates.');
      }

      throw ApiException(
        'Failed to load governorates with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print(' GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<CityModel>> fetchCities(
    String authToken,
    int governorateId,
  ) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get(
        '/governorates/$governorateId/cities',
        options: options,
      );

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is Map<String, dynamic> &&
            responsePayload['data'] is List) {
          final List<dynamic> data = responsePayload['data'];

          return data
              .whereType<Map<String, dynamic>>()
              .map(CityModel.fromJson)
              .toList();
        }
        throw ApiException('Invalid data format received for cities.');
      }

      throw ApiException(
        'Failed to load cities with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print(' GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<CityModel>> fetchAllCities(String authToken) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get('/cities', options: options);

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is Map<String, dynamic> &&
            responsePayload['data'] is List) {
          final List<dynamic> data = responsePayload['data'];

          return data
              .whereType<Map<String, dynamic>>()
              .map(CityModel.fromJson)
              .toList();
        }

        throw ApiException('Invalid data format received for cities.');
      }

      throw ApiException(
        'Failed to load cities with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<ApartmentModel>> fetchFavorites(String authToken) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.get('/user/favourites', options: options);

      print(' FAVORITES RAW RESPONSE STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic>) {
          throw ApiException('API response root is not a Map.');
        }

        final dynamic rawData = responsePayload['data'];
        if (rawData is! List) {
          throw ApiException('Invalid data format received for favorites.');
        }

        final List<dynamic> favoriteData = rawData;

        return favoriteData.whereType<Map<String, dynamic>>().map((json) {
          return ApartmentModel.fromJson(json).copyWith(isFavorite: true);
        }).toList();
      }

      throw ApiException(
        'Failed to fetch favorites with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(" not found.");
      }
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print(' GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<String> addFavorite(String authToken, int apartmentId) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.post(
        '/user/favourites/$apartmentId',
        options: options,
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Added to favorites';
      }

      throw ApiException('Unexpected error occurred');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return e.response?.data['message'] ?? 'Already in favorites';
      }

      if (e.response?.statusCode == 404) {
        throw ApiException(
          'The apartment you are trying to favorite no longer exists.',
        );
      }

      _handleDioError(e);
      rethrow;
    }
  }

  Future<String> removeFavorite(String authToken, int apartmentId) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      final response = await _dio.delete(
        '/user/favourites/$apartmentId',
        options: options,
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Apartment removed from favourites';
      }

      throw ApiException('Unexpected error occurred');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(
          'This apartment is not in your favorites or doesn\'t exist.',
        );
      }
      _handleDioError(e);
      rethrow;
    }
  }

  Future<String> rateApartment(
    String token,
    int apartmentId,
    double rating,
  ) async {
    try {
      final String rateEndpoint = '/apartments/$apartmentId/ratings';

      Response response = await _dio.post(
        rateEndpoint,
        data: {'rate': rating},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? "Apartment rated successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      String serverMessage = "An error occurred";

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          serverMessage =
              e.response?.data['message']?.toString() ?? "Validation error";
        } else {
          serverMessage = e.response?.data;
        }
      }

      final statusCode = e.response?.statusCode;

      if (statusCode == 400) {
        throw ApiException(serverMessage);
      }

      if (statusCode == 404) {
        throw ApiException(
          serverMessage.contains("error")
              ? "Apartment not found"
              : serverMessage,
        );
      }

      _handleDioError(e);

      throw ApiException(serverMessage);
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }
}
