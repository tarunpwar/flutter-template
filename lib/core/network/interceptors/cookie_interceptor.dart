import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class CookieInterceptor extends Interceptor {
  late final CookieJar _cookieJar;
  late final CookieManager _cookieManager;

  CookieInterceptor() {
    _cookieJar = CookieJar();
    _cookieManager = CookieManager(_cookieJar);
  }

  CookieManager get cookieManager => _cookieManager;

  void clearCookies() {
    _cookieJar.deleteAll();
  }
}