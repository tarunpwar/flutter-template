import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../shared/models/api_response.dart';
import 'interceptors/cookie_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final CookieInterceptor _cookieInterceptor;
  final ErrorInterceptor _errorInterceptor;

  static const String _baseUrl =
      'https://api.example.com'; // Replace with your API base URL
  static const Duration _connectionTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  ApiClient({VoidCallback? onUnauthorized, VoidCallback? onClearUserDetails})
    : _cookieInterceptor = CookieInterceptor(),
      _errorInterceptor = ErrorInterceptor(
        onUnauthorized: onUnauthorized,
        onClearUserDetails: onClearUserDetails,
      ) {
    _dio = Dio(
      BaseOptions(
      baseUrl: _baseUrl,
        connectTimeout: _connectionTimeout,
        receiveTimeout: _receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _cookieInterceptor,
      _errorInterceptor,
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
          error: true,
        ),
    ]);
  }

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return _handleGenericError<T>(e);
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return _handleGenericError<T>(e);
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return _handleGenericError<T>(e);
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return _handleGenericError<T>(e);
    }
  }

  // Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          return ApiResponse.fromJson(response.data, fromJson);
        } else {
          // Handle cases where response is not a JSON object
          return ApiResponse.success(
            data: fromJson != null ? fromJson(response.data) : response.data,
            statusCode: response.statusCode,
          );
        }
      } else {
        return ApiResponse.error(
          message: 'Request failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to parse response: $e',
        statusCode: response.statusCode,
      );
    }
  }

  // Handle DioException (errors processed by ErrorInterceptor)
  ApiResponse<T> _handleDioException<T>(DioException error) {
    if (error.error is NetworkException) {
      final networkException = error.error as NetworkException;
      return ApiResponse.error(
        message: networkException.message,
        statusCode: networkException.statusCode,
        errors: networkException.errors,
      );
    }
    
    // Fallback for unprocessed DioExceptions
    return ApiResponse.error(
      message: 'Network error: ${error.message ?? 'Unknown error'}',
      statusCode: error.response?.statusCode,
    );
  }

  // Handle generic errors
  ApiResponse<T> _handleGenericError<T>(dynamic error) {
    return ApiResponse.error(message: 'An unexpected error occurred: $error');
  }

  // Clear all cookies
  void clearCookies() {
    _cookieInterceptor.clearCookies();
  }

  // Get current cookies
  Map<String, String> get cookies => _cookieInterceptor.cookies;

  // Update base URL if needed
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  // Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  // Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}
