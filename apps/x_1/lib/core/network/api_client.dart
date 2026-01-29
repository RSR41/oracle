import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for API Client
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    // 1. Determine Base URL
    // Priority: dart-define > Web > Android(Emulator) > iOS/Desktop
    const String overrideUrl = String.fromEnvironment('API_BASE_URL');

    String baseUrl;
    if (overrideUrl.isNotEmpty) {
      baseUrl = overrideUrl;
    } else if (kIsWeb) {
      baseUrl = 'http://localhost:8080';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android Emulator loopback
      baseUrl = 'http://10.0.2.2:8080';
    } else {
      // iOS / Desktop loopback
      baseUrl = 'http://localhost:8080';
    }

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 2. Add Interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired or invalid. Clear it.
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('access_token');
          // TODO: Trigger global logout state if needed via Riverpod ref
        }
        return handler.next(e);
      },
    ));

    // 3. Debug Logging (Debug mode only)
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ));
    }
  }

  Dio get client => _dio;
}
