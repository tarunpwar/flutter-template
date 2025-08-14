class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}

class NetworkException extends ApiException {
  NetworkException({super.message = 'Network error occurred'});
}

class TimeoutException extends ApiException {
  TimeoutException({super.message = 'Request timeout'});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.message = 'Unauthorized access', super.statusCode});
      
}

class ServerException extends ApiException {
  ServerException({super.message = 'Server error occurred', super.statusCode});
}

class CacheException extends ApiException {
  CacheException({super.message = "", super.statusCode});
}

class BadRequestException extends ApiException {
  BadRequestException({super.message = "", super.statusCode});
}

class NotFoundException extends ApiException {
  NotFoundException({super.message = "", super.statusCode});
}

class ForbiddenException extends ApiException {
  ForbiddenException({super.message = "", super.statusCode});
}

class ValidationException extends ApiException {
  
  
   ValidationException( { super.message = "", super.statusCode,super.errors,});
}