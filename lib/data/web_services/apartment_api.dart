import 'package:dio/dio.dart';
import 'package:pluto_ui/constants/strings.dart';
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
}
