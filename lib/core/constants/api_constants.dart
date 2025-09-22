class ApiConstants {
  static const String acceptLanguage = 'Accept-Language';
  static const String apiVersion = '/v1';
  static const String authorization = 'Authorization';
  static const String baseUrl = 'https://api.example.com';
  // Timeouts
  static const int connectTimeout = 30000;

  // Headers
  static const String contentType = 'Content-Type';

  // Endpoints
  static const String login = '/auth/login';

  static const String logout = '/auth/logout';
  static const int receiveTimeout = 30000;
  static const String refresh = '/auth/refresh';
  static const int sendTimeout = 30000;
}