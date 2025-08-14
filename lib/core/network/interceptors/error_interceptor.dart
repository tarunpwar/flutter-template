import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _getErrorMessage(err);
    
    if (kDebugMode) {
      print('API Error: $errorMessage');
      print('Status Code: ${err.response?.statusCode}');
      print('Request URL: ${err.requestOptions.uri}');
    }

    // Create custom exception
    final apiException = ApiException(
      message: errorMessage,
      statusCode: err.response?.statusCode,
      errors: err.response?.data is Map<String, dynamic> 
          ? err.response?.data as Map<String, dynamic>
          : null,
    );

    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: apiException,
      response: err.response,
      type: err.type,
    ));
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Response timeout. Please try again.';
      case DioExceptionType.badResponse:
        return _handleHttpError(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badCertificate:
        return 'Certificate verification failed.';
      case DioExceptionType.unknown:
      return error.message ?? 'An unexpected error occurred.';
    }
  }

  String _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server error ($statusCode). Please try again.';
    }
  }
}