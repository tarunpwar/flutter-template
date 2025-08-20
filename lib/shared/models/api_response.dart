class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    try {
      return ApiResponse<T>(
        success: json['success'] ?? true,
        message: json['message'],
        data: json['data'] != null && fromJsonT != null
            ? fromJsonT(json['data'])
            : json['data'],
        statusCode: json['status_code'],
        errors: json['errors'],
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Failed to parse response',
        statusCode: null,
      );
    }
  }
}