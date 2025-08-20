import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const NetworkException({required this.message, this.statusCode, this.errors});

  @override
  String toString() => message;
}

class ErrorInterceptor extends Interceptor {
  final VoidCallback? onUnauthorized;
  final VoidCallback? onClearUserDetails;

  ErrorInterceptor({this.onUnauthorized, this.onClearUserDetails});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 unauthorized
    if (err.response?.statusCode == 401) {
      onClearUserDetails?.call();
      onUnauthorized?.call();
    }

    // Transform DioException to NetworkException with proper error handling
    final networkException = _transformError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: networkException,
        message: networkException.message,
      ),
    );
  }

  NetworkException _transformError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Request timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
          statusCode: error.response?.statusCode,
        );

      default:
        return NetworkException(
          message:
              'An unexpected error occurred: ${error.message ?? 'Unknown error'}',
          statusCode: error.response?.statusCode,
        );
    }
  }

  NetworkException _handleBadResponse(DioException error) {
    final response = error.response;

    if (response?.data is Map<String, dynamic>) {
      final responseData = response!.data as Map<String, dynamic>;

      return NetworkException(
        message:
            responseData['message'] ??
            responseData['error'] ??
            'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
        errors: responseData['errors'],
      );
    } else {
      return NetworkException(
        message:
            'Request failed with status: ${response?.statusCode ?? 'Unknown'}',
        statusCode: response?.statusCode,
      );
    }
  }
}
