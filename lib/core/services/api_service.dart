import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/navigator_key.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://31.97.98.47:9000/api/'),
      connectTimeout: const Duration(minutes: 10),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static void init() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && !(options.extra['open'] == true)) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'access_token');
          // Optionally, you can use a callback or event to trigger navigation to login
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
          }
        }
        return handler.next(e);
      },
    ));
  }

  static Future<Response<T>> request<T>({
    required String url,
    bool open = false,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final options = Options(
      method: method,
      headers: headers,
      extra: {'open': open},
    );
    return _dio.request<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

 