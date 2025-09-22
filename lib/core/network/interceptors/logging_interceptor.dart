// core/network/interceptors/logging_interceptor.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    Logger? logger,
    this.logRequestHeaders = true,
    this.logRequestBody = true,
    this.logResponseHeaders = false,
    this.logResponseBody = true,
    this.logErrors = true,
    this.excludeHeaders = const ['authorization', 'cookie', 'set-cookie'],
    this.sensitiveFields = const ['password', 'token', 'secret', 'key'],
  }) : _logger = logger ?? Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTime,
          ),
        );

  final List<String> excludeHeaders;
  final bool logErrors;
  final bool logRequestBody;
  final bool logRequestHeaders;
  final bool logResponseBody;
  final bool logResponseHeaders;
  final List<String> sensitiveFields;

  final Logger _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logErrors) {
      _logError(err);
    }
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);
    super.onResponse(response, handler);
  }

  void _logRequest(RequestOptions options) {
    _logger.i('╭─────── Request ────────');
    _logger.i('│ ${options.method.toUpperCase()} ${options.uri}');
    
    if (logRequestHeaders && options.headers.isNotEmpty) {
      _logger.i('│ Headers:');
      final filteredHeaders = _filterSensitiveHeaders(options.headers);
      filteredHeaders.forEach((key, value) {
        _logger.i('│   $key: $value');
      });
    }

    if (logRequestBody && options.data != null) {
      _logger.i('│ Body:');
      final bodyString = _formatRequestBody(options.data);
      final sanitizedBody = _sanitizeSensitiveData(bodyString);
      _logger.i('│   $sanitizedBody');
    }

    if (options.queryParameters.isNotEmpty) {
      _logger.i('│ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        final sanitizedValue = _sanitizeValue(key, value.toString());
        _logger.i('│   $key: $sanitizedValue');
      });
    }

    _logger.i('╰────────────────────────');
  }

  void _logResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final statusMessage = response.statusMessage ?? '';
    final isSuccess = statusCode >= 200 && statusCode < 300;
    
    if (isSuccess) {
      _logger.i('╭─────── Response ───────');
      _logger.i('│ ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');
      _logger.i('│ Status: $statusCode $statusMessage');
    } else {
      _logger.w('╭─────── Response ───────');
      _logger.w('│ ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');
      _logger.w('│ Status: $statusCode $statusMessage');
    }

    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      _logger.i('│ Headers:');
      response.headers.map.forEach((key, value) {
        if (!_isExcludedHeader(key)) {
          _logger.i('│   $key: ${value.join(', ')}');
        }
      });
    }

    if (logResponseBody && response.data != null) {
      _logger.i('│ Body:');
      final bodyString = _formatResponseBody(response.data);
      final truncatedBody = _truncateIfNeeded(bodyString);
      _logger.i('│   $truncatedBody');
    }

    _logger.i('╰────────────────────────');
  }

  void _logError(DioException error) {
    _logger.e('╭─────── Error ──────────');
    _logger.e('│ ${error.requestOptions.method.toUpperCase()} ${error.requestOptions.uri}');
    _logger.e('│ Error Type: ${error.type}');
    _logger.e('│ Message: ${error.message}');

    if (error.response != null) {
      final response = error.response!;
      _logger.e('│ Status Code: ${response.statusCode}');
      _logger.e('│ Status Message: ${response.statusMessage}');
      
      if (response.data != null) {
        _logger.e('│ Error Body:');
        final bodyString = _formatResponseBody(response.data);
        _logger.e('│   $bodyString');
      }
    }

    _logger.e('│ Stack Trace:');
    final stackLines = error.stackTrace.toString().split('\n');
    for (int i = 0; i < stackLines.length && i < 5; i++) {
      _logger.e('│   ${stackLines[i]}');
    }
  
    _logger.e('╰────────────────────────');
  }

  String _formatRequestBody(dynamic data) {
    try {
      if (data is String) {
        return data;
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      } else if (data is FormData) {
        return _formatFormData(data);
      } else {
        return data.toString();
      }
    } catch (e) {
      return 'Failed to format request body: $e';
    }
  }

  String _formatResponseBody(dynamic data) {
    try {
      if (data is String) {
        // Try to parse as JSON for pretty printing
        try {
          final jsonData = jsonDecode(data);
          return const JsonEncoder.withIndent('  ').convert(jsonData);
        } catch (_) {
          return data;
        }
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      } else {
        return data.toString();
      }
    } catch (e) {
      return 'Failed to format response body: $e';
    }
  }

  String _formatFormData(FormData formData) {
    final buffer = StringBuffer();
    buffer.writeln('FormData:');
    
    for (final field in formData.fields) {
      final sanitizedValue = _sanitizeValue(field.key, field.value);
      buffer.writeln('  ${field.key}: $sanitizedValue');
    }
    
    for (final file in formData.files) {
      buffer.writeln('  ${file.key}: ${file.value.filename} (${file.value.length} bytes)');
    }
    
    return buffer.toString().trim();
  }

  Map<String, dynamic> _filterSensitiveHeaders(Map<String, dynamic> headers) {
    final filtered = <String, dynamic>{};
    
    headers.forEach((key, value) {
      if (_isExcludedHeader(key.toLowerCase())) {
        filtered[key] = '***';
      } else {
        filtered[key] = value;
      }
    });
    
    return filtered;
  }

  bool _isExcludedHeader(String headerName) {
    return excludeHeaders.any(
      (excluded) => headerName.toLowerCase().contains(excluded.toLowerCase()),
    );
  }

  String _sanitizeSensitiveData(String data) {
    String sanitized = data;
    
    for (final field in sensitiveFields) {
      // Replace sensitive field values in JSON-like strings
      final regex = RegExp(
        '"$field"\\s*:\\s*"[^"]*"',
        caseSensitive: false,
      );
      sanitized = sanitized.replaceAll(regex, '"$field": "***"');
      
      // Replace sensitive field values in form-like strings
      final formRegex = RegExp(
        '$field\\s*[:=]\\s*[^\\s,}&]+',
        caseSensitive: false,
      );
      sanitized = sanitized.replaceAll(formRegex, '$field: ***');
    }
    
    return sanitized;
  }

  String _sanitizeValue(String key, String value) {
    if (sensitiveFields.any((field) => key.toLowerCase().contains(field.toLowerCase()))) {
      return '***';
    }
    return value;
  }

  String _truncateIfNeeded(String text, {int maxLength = 1000}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}... (truncated ${text.length - maxLength} characters)';
  }
}

// Enhanced Logger Configuration
class NetworkLogger {
  static Logger createLogger({
    Level level = Level.debug,
    bool printTime = true,
    bool printEmojis = true,
    bool colors = true,
    int methodCount = 0,
    int errorMethodCount = 5,
    int lineLength = 120,
  }) {
    return Logger(
      level: level,
      printer: PrettyPrinter(
        methodCount: methodCount,
        errorMethodCount: errorMethodCount,
        lineLength: lineLength,
        colors: colors,
        printEmojis: printEmojis,
        dateTimeFormat: DateTimeFormat.onlyTime,
      ),
      output: ConsoleOutput(),
    );
  }
}

// Usage Example in API Client
// class ApiClient {
//   late final Dio _dio;
//   final Logger _logger = NetworkLogger.createLogger();

//   ApiClient({
//     String? baseUrl,
//     Duration? connectTimeout,
//     Duration? receiveTimeout,
//     bool enableLogging = true,
//   }) {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl ?? 'https://api.example.com',
//       connectTimeout: connectTimeout ?? const Duration(seconds: 30),
//       receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     ));

//     if (enableLogging) {
//       _dio.interceptors.add(
//         LoggingInterceptor(
//           logger: _logger,
//           logRequestHeaders: true,
//           logRequestBody: true,
//           logResponseHeaders: false,
//           logResponseBody: true,
//           logErrors: true,
//           excludeHeaders: ['authorization', 'cookie', 'x-api-key'],
//           sensitiveFields: ['password', 'token', 'secret', 'api_key'],
//         ),
//       );
//     }
//   }

// }

/// Simplified logging interceptor for HTTP requests using the logger package
// class LoggingInterceptor extends Interceptor {
//   final Logger _logger;
//   final bool logHeaders;
//   final bool logRequestBody;
//   final bool logResponseBody;
//   final bool logErrors;

//   LoggingInterceptor({
//     Logger? logger,
//     this.logHeaders = true,
//     this.logRequestBody = true,
//     this.logResponseBody = true,
//     this.logErrors = true,
//   }) : _logger = logger ?? Logger(
//           printer: PrettyPrinter(
//             methodCount: 0,
//             errorMethodCount: 5,
//             lineLength: 75,
//             colors: true,
//             printEmojis: true,
//             dateTimeFormat: DateTimeFormat.onlyTime,
//           ),
//         );

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     _logRequest(options);
//     super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     _logResponse(response);
//     super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (logErrors) {
//       _logError(err);
//     }
//     super.onError(err, handler);
//   }

//   void _logRequest(RequestOptions options) {
//     _logger.i('┌─────────────────────────────────────────────────────────────');
//     _logger.i('│ 🚀 REQUEST');
//     _logger.i('├─────────────────────────────────────────────────────────────');
//     _logger.i('│ Method: ${options.method}');
//     _logger.i('│ URL: ${options.uri}');
    
//     if (logHeaders && options.headers.isNotEmpty) {
//       _logger.i('│ Headers:');
//       options.headers.forEach((key, value) {
//         _logger.i('│   $key: $value');
//       });
//     }

//     if (logRequestBody && options.data != null) {
//       _logger.i('│ Body: ${_formatData(options.data)}');
//     }

//     if (options.queryParameters.isNotEmpty) {
//       _logger.i('│ Query Parameters:');
//       options.queryParameters.forEach((key, value) {
//         _logger.i('│   $key: $value');
//       });
//     }

//     _logger.i('└─────────────────────────────────────────────────────────────');
//   }

//   void _logResponse(Response response) {
//     final statusCode = response.statusCode ?? 0;
//     final isSuccess = statusCode >= 200 && statusCode < 300;
    
//     _logger.i('┌─────────────────────────────────────────────────────────────');
//     _logger.i('│ ${isSuccess ? '✅' : '⚠️'} RESPONSE');
//     _logger.i('├─────────────────────────────────────────────────────────────');
//     _logger.i('│ Status Code: $statusCode');
//     _logger.i('│ URL: ${response.requestOptions.uri}');
//     _logger.i('│ Method: ${response.requestOptions.method}');

//     if (logHeaders && response.headers.map.isNotEmpty) {
//       _logger.i('│ Headers:');
//       response.headers.map.forEach((key, value) {
//         _logger.i('│   $key: ${value.join(', ')}');
//       });
//     }

//     if (logResponseBody && response.data != null) {
//       _logger.i('│ Response Body: ${_formatData(response.data)}');
//     }

//     _logger.i('└─────────────────────────────────────────────────────────────');
//   }

//   void _logError(DioException error) {
//     _logger.e('┌─────────────────────────────────────────────────────────────');
//     _logger.e('│ ❌ ERROR');
//     _logger.e('├─────────────────────────────────────────────────────────────');
//     _logger.e('│ Error Type: ${error.type}');
//     _logger.e('│ Error Message: ${error.message}');
    
//     if (error.response != null) {
//       _logger.e('│ Status Code: ${error.response?.statusCode}');
//       _logger.e('│ URL: ${error.requestOptions.uri}');
//       _logger.e('│ Method: ${error.requestOptions.method}');
      
//       if (error.response?.data != null) {
//         _logger.e('│ Error Response: ${_formatData(error.response?.data)}');
//       }
//     }

//     _logger.e('│ Stack Trace:');
//     _logger.e(error.stackTrace.toString());
  
//     _logger.e('└─────────────────────────────────────────────────────────────');
//   }

//   String _formatData(dynamic data) {
//     try {
//       if (data is Map || data is List) {
//         // For complex objects, convert to JSON string with indentation
//         return const JsonEncoder.withIndent('  ').convert(data);
//       } else if (data is String) {
//         // Try to parse and format JSON strings
//         try {
//           final decoded = jsonDecode(data);
//           return const JsonEncoder.withIndent('  ').convert(decoded);
//         } catch (_) {
//           return data;
//         }
//       }
//       return data.toString();
//     } catch (e) {
//       return 'Unable to format data: $e';
//     }
//   }
// }

// // Usage example with Dio
// class ApiClient {
//   late final Dio _dio;
  
//   ApiClient({String? baseUrl}) {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl ?? 'https://api.example.com',
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//     ));

//     // Add the logging interceptor
//     _dio.interceptors.add(LoggingInterceptor(
//       logHeaders: true,
//       logRequestBody: true,
//       logResponseBody: true,
//       logErrors: true,
//     ));
//   }

//   Dio get dio => _dio;
// }

// // Alternative: Custom Logger Configuration
// class CustomLoggingInterceptor extends LoggingInterceptor {
//   CustomLoggingInterceptor() : super(
//     logger: Logger(
//       level: Level.debug,
//       printer: SimplePrinter(
//         colors: false,
//         printTime: true,
//       ),
//       output: ConsoleOutput(),
//     ),
//     logHeaders: false, // Disable headers in production
//     logRequestBody: true,
//     logResponseBody: false, // Disable response body in production
//     logErrors: true,
//   );
// }

// // Production-ready logging interceptor
// class ProductionLoggingInterceptor extends LoggingInterceptor {
//   ProductionLoggingInterceptor() : super(
//     logger: Logger(
//       level: Level.warning, // Only log warnings and errors in production
//       printer: SimplePrinter(
//         colors: false,
//         printTime: true,
//       ),
//     ),
//     logHeaders: false,
//     logRequestBody: false,
//     logResponseBody: false,
//     logErrors: true, // Always log errors
//   );
// }