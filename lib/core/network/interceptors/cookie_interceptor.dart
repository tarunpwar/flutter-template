import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CookieInterceptor extends Interceptor {
  final Map<String, String> _cookies = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add stored cookies to request
    if (_cookies.isNotEmpty) {
      final cookieString = _cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; ');
      options.headers['Cookie'] = cookieString;
    }

    if (kDebugMode) {
      print('REQUEST: ${options.method} ${options.uri}');
      print('COOKIES: ${options.headers['Cookie'] ?? 'None'}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Extract and store cookies from response
    final setCookieHeaders = response.headers['set-cookie'];
    if (setCookieHeaders != null) {
      for (final cookieHeader in setCookieHeaders) {
        _extractAndStoreCookie(cookieHeader);
      }
    }

    if (kDebugMode) {
      print('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      print('SET-COOKIE: $setCookieHeaders');
    }
    
    handler.next(response);
  }

  void clearCookies() {
    _cookies.clear();
  }

  Map<String, String> get cookies => Map.unmodifiable(_cookies);

  void _extractAndStoreCookie(String cookieHeader) {
    final cookie = cookieHeader.split(';').first;
    final parts = cookie.split('=');
    if (parts.length == 2) {
      final name = parts[0].trim();
      final value = parts[1].trim();
      _cookies[name] = value;
    }
  }
}