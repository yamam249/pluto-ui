import 'package:dio/dio.dart';
import 'package:pluto_ui/constants/strings.dart';
import 'package:pluto_ui/data/models/city_model.dart';
import 'package:pluto_ui/data/models/governorate_model.dart';
import 'package:pluto_ui/data/web_services/login_api.dart' show ApiException;
import '../models/apartment_model.dart';

class ApartmentApi {
  static const String _endpoint = '/apartments';
  final Dio _dio;

  ApartmentApi._internal()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

  static final ApartmentApi _singleton = ApartmentApi._internal();

  factory ApartmentApi() => _singleton;

  // --- Helper Function for Consistent Error Handling ---
  void _handleDioError(DioException e) {
    print('❌ DIO EXCEPTION CAUGHT: ${e.response?.statusCode ?? e.type}');
    print('❌ DIO EXCEPTION DATA: ${e.response?.data}');

    if (e.response?.statusCode == 401) {
      throw ApiException('Unauthorized: Session expired or invalid token.');
    }
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
  // ----------------------------------------------------

  /// Fetches a list of apartments from the API.
  /// Filters are passed as key-value pairs
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
      print('✅ RAW DIO RESPONSE STATUS: ${response.statusCode}');
      print('✅ RAW DIO RESPONSE DATA: ${response.data}');
      if (response.statusCode == 200) {
        print('✅ RAW API SUCCESS RESPONSE: ${response.data}');

        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic>) {
          throw ApiException(
            'API response root is not a Map: ${response.data.toString()}',
          );
        }

        // Safely access 'data' from the validated map
        final dynamic rawData = responsePayload['data'];
        if (rawData is! List) {
          // If the 'data' field is not a list (e.g., if it's null or a string error)
          throw ApiException('Invalid data format received from server.');
        }

        // Now we know it's a List, we can proceed.
        final List<dynamic> apartmentData = rawData;

        return apartmentData
            .whereType<
              Map<String, dynamic>
            >() // Filter out any non-map elements (like an error String)
            .map(ApartmentModel.fromJson)
            .toList();
      }

      // Note: Dio handles most non-2xx status codes by throwing a DioException,
      // so this specific check might be redundant but is here for safety.
      throw ApiException(
        'Failed to fetch apartments with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow; // Re-throw the handled exception
    } on Exception catch (e) {
      print('💥 GENERAL EXCEPTION CAUGHT: ${e.toString()}');

      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  ///  Fetches details for a single apartment by ID.
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

      print('✅ DETAIL RAW DIO RESPONSE STATUS: ${response.statusCode}');
      if (response.statusCode == 200) {
        final dynamic responsePayload = response.data;

        if (responsePayload is! Map<String, dynamic>) {
          throw ApiException('API response root is not a Map.');
        }

        final dynamic rawData = responsePayload['data'];

        // Check if 'data' is the expected single apartment Map
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
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print('💥 GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches the list of governorates for the filter dropdown.
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
              .whereType<
                Map<String, dynamic>
              >() // Ensure each item in the list is a Map
              .map(GovernorateModel.fromJson)
              .toList();
        }

        throw ApiException('Invalid data format received for governorates.');
      }

      throw ApiException(
        'Failed to load governorates with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print('💥 GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches cities belonging to a specific governorate.
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

        // Validation check for the data format
        if (responsePayload is Map<String, dynamic> &&
            responsePayload['data'] is List) {
          final List<dynamic> data = responsePayload['data'];

          return data
              .whereType<Map<String, dynamic>>() // Ensure each item is a Map
              .map(CityModel.fromJson)
              .toList();
        }
        throw ApiException('Invalid data format received for cities.');
      }

      throw ApiException(
        'Failed to load cities with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print('💥 GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches all cities (no governorate filter)
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
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches the user's list of favorite apartments.
  Future<List<ApartmentModel>> fetchFavorites(String authToken) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      // Note: The endpoint provided was /user/favourites
      final response = await _dio.get('/user/favourites', options: options);

      print('✅ FAVORITES RAW RESPONSE STATUS: ${response.statusCode}');

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
          // We use the existing fromJson, which handles missing detail fields (price, rooms, etc.)
          // AND we force isFavorite to true because these are from the favorites list.
          return ApartmentModel.fromJson(json).copyWith(isFavorite: true);
        }).toList();
      }

      throw ApiException(
        'Failed to fetch favorites with status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      print('💥 GENERAL EXCEPTION CAUGHT: ${e.toString()}');
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Adds an apartment to favorites by its ID.
  Future<String> addFavorite(String authToken, int apartmentId) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $authToken'});

      // The endpoint is /user/favourites/{id}
      final response = await _dio.post(
        '/user/favourites/$apartmentId',
        options: options,
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Added to favorites';
      }

      throw ApiException('Unexpected error occurred');
    } on DioException catch (e) {
      // Special handling for 409: Already in favorites
      if (e.response?.statusCode == 409) {
        return e.response?.data['message'] ?? 'Already in favorites';
      }

      // Special handling for 404: Apartment not found
      if (e.response?.statusCode == 404) {
        throw ApiException(
          'The apartment you are trying to favorite no longer exists.',
        );
      }

      _handleDioError(e);
      rethrow;
    }
  }

  /// Removes an apartment from favorites by its ID.
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
      // Note: The endpoint is /apartments/{id}/ratings
      final String rateEndpoint = '/apartments/$apartmentId/ratings';

      Response response = await _dio.post(
        rateEndpoint,
        data: {
          'rate': rating, // Matches $validated['rate'] in your PHP controller
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? "Apartment rated successfully";
      }

      throw ApiException("Unexpected response from server.");
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // Explicit handling for your required status codes
      if (statusCode == 404) {
        throw ApiException("Apartment not found.");
      }
      if (statusCode == 400) {
        throw ApiException("Bad Request: Invalid rating data.");
      }

      // Reuse your existing global error handler
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw ApiException("An unexpected error occurred: ${e.toString()}");
    }
  }
}
