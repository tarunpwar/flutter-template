import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_config.dart';
import '../../shared/models/api_response.dart';
import '../errors/exceptions.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiService {
  // final Map<String, String> _defaultHeaders = {
  //   'Content-Type': 'application/json',
  //   'Accept': 'application/json',
  //   'Authorization': 'Bearer ${AppConfig.apiKey}',
  // };

  // Singleton pattern
  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  ApiService._internal() {
    _dio = Dio();
    _initializeDio();
  }

  static ApiService? _instance;

  // Base URL - change this to your API base URL
  final String _baseUrl = AppConfig.apiBaseUrl;

  late Dio _dio;

  // Set authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authorization token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // File upload
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath,
    String fileKey, {
    Map<String, dynamic>? additionalData,
    T Function(dynamic)? fromJson,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // Cancel all requests
  void cancelAllRequests() {
    _dio.close(force: true);
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(ErrorInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  // Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final data = response.data;

    // If fromJson is provided, use it to parse the data
    T? parsedData;
    if (fromJson != null && data != null) {
      // Handle both single objects and lists
      if (data is List) {
        parsedData = data.map((item) => fromJson(item)).toList() as T;
      } else {
        parsedData = fromJson(data);
      }
    } else {
      parsedData = data as T?;
    }

    return ApiResponse.success(
      data: parsedData,
      message: _extractMessage(data),
      statusCode: response.statusCode,
    );
  }

  // Handle error response
  ApiResponse<T> _handleError<T>(DioException error) {
    if (error.error is ApiException) {
      final apiException = error.error as ApiException;
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        errors: apiException.errors,
      );
    }

    return ApiResponse.error(
      message: error.message ?? 'An unexpected error occurred',
      statusCode: error.response?.statusCode,
    );
  }

  // Extract message from response data
  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['msg'] as String? ??
          data['error'] as String?;
    }
    return null;
  }
}

// Usage Example - user_repository.dart
// class User {
//   final int id;
//   final String name;
//   final String email;

//   User({required this.id, required this.name, required this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(id: json['id'], name: json['name'], email: json['email']);
//   }

//   Map<String, dynamic> toJson() {
//     return {'id': id, 'name': name, 'email': email};
//   }
// }

// class UserRepository {
//   final ApiService _apiService = ApiService();

//   // Get all users
//   Future<ApiResponse<List<User>>> getUsers() async {
//     return await _apiService.get<List<User>>(
//       'users',
//       fromJson: (data) =>
//           (data as List).map((item) => User.fromJson(item)).toList(),
//     );
//   }

//   // Get user by ID
//   Future<ApiResponse<User>> getUserById(int id) async {
//     return await _apiService.get<User>(
//       'users/$id',
//       fromJson: (data) => User.fromJson(data),
//     );
//   }

//   // Create user
//   Future<ApiResponse<User>> createUser(User user) async {
//     return await _apiService.post<User>(
//       'users',
//       data: user.toJson(),
//       fromJson: (data) => User.fromJson(data),
//     );
//   }

//   // Update user
//   Future<ApiResponse<User>> updateUser(int id, User user) async {
//     return await _apiService.put<User>(
//       'users/$id',
//       data: user.toJson(),
//       fromJson: (data) => User.fromJson(data),
//     );
//   }

//   // Delete user
//   Future<ApiResponse<void>> deleteUser(int id) async {
//     return await _apiService.delete<void>('users/$id');
//   }
// }

// Enhanced ApiService with batch operations
// extension BatchOperations on ApiService {
//   // Execute multiple requests concurrently
//   Future<List<ApiResponse<T>>> batch<T>(
//     List<Future<ApiResponse<T>>> requests,
//   ) async {
//     try {
//       // Wait for all requests to complete (even if some fail)
//       final results = await Future.wait(
//         requests,
//         eagerError: false, // Don't stop on first error
//       );
//       return results;
//     } catch (e) {
//       // This shouldn't happen due to eagerError: false
//       // But just in case, return empty list
//       return [];
//     }
//   }

//   // Execute multiple different types of requests
//   Future<Map<String, dynamic>> batchMixed(
//     Map<String, Future<ApiResponse<dynamic>>> requests,
//   ) async {
//     final results = <String, dynamic>{};

//     // Execute all requests concurrently
//     final futures = requests.map(
//       (key, future) => MapEntry(
//         key,
//         future
//             .then(
//               (response) => {
//                 'success': response.success,
//                 'data': response.data,
//                 'message': response.message,
//                 'statusCode': response.statusCode,
//                 'errors': response.errors,
//               },
//             )
//             .catchError(
//               (error) => {'success': false, 'error': error.toString()},
//             ),
//       ),
//     );

//     await Future.wait(futures.values, eagerError: false);

//     for (final entry in futures.entries) {
//       results[entry.key] = await entry.value;
//     }

//     return results;
//   }
// }

// Concurrent request examples and usage patterns
// class ConcurrentApiExamples {
//   final ApiService _apiService = ApiService();
//   final UserRepository _userRepository = UserRepository();

//   // Example 1: Multiple similar requests
//   Future<void> loadMultipleUsers() async {
//     debugPrint('Starting concurrent user requests...');

//     // These will execute concurrently
//     final futures = [
//       _userRepository.getUserById(1),
//       _userRepository.getUserById(2),
//       _userRepository.getUserById(3),
//       _userRepository.getUserById(999), // This might fail (not found)
//     ];

//     final results = await _apiService.batch(futures);

//     for (int i = 0; i < results.length; i++) {
//       final result = results[i];
//       if (result.success) {
//         debugPrint('User ${i + 1}: ${result.data?.name}');
//       } else {
//         debugPrint('Failed to load user ${i + 1}: ${result.message}');
//       }
//     }
//   }

//   // Example 2: Different types of requests
//   Future<void> loadDashboardData() async {
//     debugPrint('Loading dashboard data concurrently...');

//     final requests = {
//       'users': _userRepository.getUsers(),
//       'profile': _userRepository.getUserById(1),
//       'settings': _apiService.get('settings'),
//       'notifications': _apiService.get('notifications'),
//     };

//     final results = await _apiService.batchMixed(requests);

//     // Handle each result independently
//     if (results['users']['success']) {
//       debugPrint('Users loaded: ${results['users']['data']?.length} users');
//     } else {
//       debugPrint('Failed to load users: ${results['users']['message']}');
//     }

//     if (results['profile']['success']) {
//       debugPrint('Profile loaded for: ${results['profile']['data']?.name}');
//     } else {
//       debugPrint('Failed to load profile: ${results['profile']['message']}');
//     }

//     // Even if some requests failed, others can still succeed
//   }

//   // Example 3: With individual error handling
//   Future<void> loadDataWithIndividualHandling() async {
//     // Start all requests concurrently
//     final usersFuture = _userRepository.getUsers();
//     final profileFuture = _userRepository.getUserById(1);
//     final settingsFuture = _apiService.get('settings');

//     // Handle each as they complete
//     final usersResult = await usersFuture;
//     final profileResult = await profileFuture;
//     final settingsResult = await settingsFuture;

//     // Process results independently
//     if (usersResult.success) {
//       debugPrint('✅ Users loaded successfully');
//     } else {
//       debugPrint('❌ Users failed: ${usersResult.message}');
//     }

//     if (profileResult.success) {
//       debugPrint('✅ Profile loaded successfully');
//     } else {
//       debugPrint('❌ Profile failed: ${profileResult.message}');
//     }

//     if (settingsResult.success) {
//       debugPrint('✅ Settings loaded successfully');
//     } else {
//       debugPrint('❌ Settings failed: ${settingsResult.message}');
//     }
//   }

//   // Example 4: With timeout and cancellation
//   Future<void> loadWithTimeoutAndCancellation() async {
//     final cancelToken = CancelToken();

//     // Cancel all requests after 10 seconds
//     Timer(Duration(seconds: 10), () {
//       cancelToken.cancel('Request timeout');
//     });

//     try {
//       final futures = [
//         _apiService.get('users', cancelToken: cancelToken),
//         _apiService.get('posts', cancelToken: cancelToken),
//         _apiService.get('comments', cancelToken: cancelToken),
//       ];

//       final results = await _apiService.batch(futures);

//       for (int i = 0; i < results.length; i++) {
//         if (results[i].success) {
//           debugPrint('Request $i completed successfully');
//         } else {
//           debugPrint('Request $i failed: ${results[i].message}');
//         }
//       }
//     } catch (e) {
//       debugPrint('Batch operation error: $e');
//     }
//   }
// }

// Usage in a Widget - Concurrent Loading Example
/*
class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final UserRepository _userRepository = UserRepository();
  final ApiService _apiService = ApiService();
  
  List<User>? users;
  User? currentUser;
  Map<String, dynamic>? settings;
  List<String> errors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      isLoading = true;
      errors.clear();
    });

    // Execute all requests concurrently
    final requests = {
      'users': _userRepository.getUsers(),
      'profile': _userRepository.getUserById(1),
      'settings': _apiService.get<Map<String, dynamic>>('settings'),
    };

    final results = await _apiService.batchMixed(requests);
    
    // Handle results
    if (results['users']['success']) {
      users = results['users']['data'];
    } else {
      errors.add('Failed to load users: ${results['users']['message']}');
    }

    if (results['profile']['success']) {
      currentUser = results['profile']['data'];
    } else {
      errors.add('Failed to load profile: ${results['profile']['message']}');
    }

    if (results['settings']['success']) {
      settings = results['settings']['data'];
    } else {
      errors.add('Failed to load settings: ${results['settings']['message']}');
    }

    setState(() => isLoading = false);
    
    // Show errors if any (but don't prevent successful data from showing)
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${errors.length} request(s) failed'),
          action: SnackBarAction(
            label: 'Details',
            onPressed: () => _showErrorDetails(),
          ),
        ),
      );
    }
  }

  void _showErrorDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Errors'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: errors.map((error) => Text('• $error')).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          // Show current user even if other requests failed
          if (currentUser != null)
            Card(
              child: ListTile(
                title: Text('Welcome, ${currentUser!.name}'),
                subtitle: Text(currentUser!.email),
              ),
            ),
          
          // Show users list even if profile or settings failed
          if (users != null)
            Expanded(
              child: ListView.builder(
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  final user = users![index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  );
                },
              ),
            ),
          
          // Show settings info if available
          if (settings != null)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Settings loaded: ${settings!.keys.length} items'),
              ),
            ),
        ],
      ),
    );
  }
}
*/
