import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pluto_ui/constants/strings.dart';
import 'package:pluto_ui/data/local_storage/secure_storage_service.dart';
import 'package:pluto_ui/main.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getDio() {
    if (_dio != null) return _dio!;

    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print(" Unauthorized , moving user to login");

            ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
            await SecureStorageService().deleteToken();

            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
          return handler.next(e);
        },
      ),
    );

    return _dio!;
  }
}
