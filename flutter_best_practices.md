# Flutter Development Best Practices Guide

## Table of Contents
1. [Naming Conventions](#naming-conventions)
2. [Project Structure](#project-structure)
3. [Code Organization](#code-organization)
4. [Widget Best Practices](#widget-best-practices)
5. [State Management](#state-management)
6. [Error Handling](#error-handling)
7. [Testing](#testing)
8. [Documentation](#documentation)
9. [Performance](#performance)
10. [Security](#security)

## Naming Conventions

### File and Directory Names
- Use **snake_case** for file and directory names
- Use descriptive names that clearly indicate the file's purpose

```
✅ Good
user_profile_screen.dart
auth_service.dart
product_repository.dart

❌ Bad
UserProfileScreen.dart
authService.dart
productRepo.dart
```

### Class Names
- Use **PascalCase** for class names
- Use descriptive names that indicate the class purpose

```dart
✅ Good
class UserProfileScreen extends StatefulWidget {}
class AuthenticationService {}
class ProductRepository {}

❌ Bad
class userprofilescreen extends StatefulWidget {}
class authService {}
class prodRepo {}
```

### Variable and Method Names
- Use **camelCase** for variables, methods, and parameters
- Use descriptive names that explain the purpose

```dart
✅ Good
String userName;
void fetchUserData() {}
bool isUserLoggedIn;

❌ Bad
String usrNm;
void fetchData() {}
bool loggedIn;
```

### Constants
- Use **lowerCamelCase** for constants
- Group related constants in classes

```dart
✅ Good
const String apiBaseUrl = 'https://api.example.com';
const Duration timeoutDuration = Duration(seconds: 30);

class AppConstants {
  static const String appName = 'MyApp';
  static const int maxRetries = 3;
}
```

### Widget Naming
- Screen widgets should end with `Screen` or `Page`
- Custom widgets should have descriptive names
- Stateless widgets are preferred when possible

```dart
✅ Good
class HomeScreen extends StatelessWidget {}
class CustomButton extends StatelessWidget {}
class LoadingIndicator extends StatelessWidget {}

❌ Bad
class Home extends StatefulWidget {} // When StatelessWidget would suffice
class Button extends StatelessWidget {} // Too generic
```

## Project Structure

### Recommended Directory Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── routes/
│       ├── app_routes.dart
│       └── route_generator.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── asset_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── network_info.dart
│   │   └── dio_client.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   └── string_extensions.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       └── text_styles.dart
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── home/
│       └── [same structure as authentication]
├── shared/
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── inputs/
│   │   └── loading/
│   └── services/
│       ├── local_storage_service.dart
│       └── notification_service.dart
└── generated/
    └── [auto-generated files]
```

### Feature-First Organization
Organize code by features rather than by file types. Each feature should contain its own data, domain, and presentation layers.

## Code Organization

### Imports Organization
Order imports in the following sequence:
1. Dart core libraries
2. Flutter libraries
3. Third-party packages
4. Local imports (relative imports)

```dart
✅ Good
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../models/user.dart';
import '../services/api_service.dart';
```

### Class Member Organization
Organize class members in the following order:
1. Static constants
2. Instance variables
3. Constructors
4. Override methods
5. Public methods
6. Private methods

```dart
class UserProfileScreen extends StatefulWidget {
  // 1. Static constants
  static const String routeName = '/user-profile';
  
  // 2. Instance variables
  final String userId;
  final bool isEditable;
  
  // 3. Constructor
  const UserProfileScreen({
    Key? key,
    required this.userId,
    this.isEditable = false,
  }) : super(key: key);
  
  // 4. Override methods
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}
```

## Widget Best Practices

### StatelessWidget vs StatefulWidget
- Prefer **StatelessWidget** when the widget doesn't need to manage state
- Use **StatefulWidget** only when you need to manage mutable state

```dart
✅ Good - StatelessWidget for static content
class WelcomeMessage extends StatelessWidget {
  final String userName;
  
  const WelcomeMessage({Key? key, required this.userName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text('Welcome, $userName!');
  }
}

✅ Good - StatefulWidget for dynamic content
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}
```

### Widget Composition
- Break down complex widgets into smaller, reusable components
- Use composition over inheritance

```dart
✅ Good - Composed of smaller widgets
class UserCard extends StatelessWidget {
  final User user;
  
  const UserCard({Key? key, required this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          UserAvatar(user: user),
          UserInfo(user: user),
          UserActions(user: user),
        ],
      ),
    );
  }
}

❌ Bad - Monolithic widget
class UserCard extends StatelessWidget {
  // One large build method with all UI logic
}
```

### Widget Keys
- Use keys when widgets of the same type need to be distinguished
- Prefer `ValueKey` for widgets with unique data
- Use `GlobalKey` sparingly and only when necessary

```dart
✅ Good
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id),
      title: Text(items[index].name),
    );
  },
)
```

### Build Method Optimization
- Keep build methods pure (no side effects)
- Extract complex widget trees into separate methods or widgets
- Use `const` constructors whenever possible

```dart
✅ Good
class ProductCard extends StatelessWidget {
  final Product product;
  
  const ProductCard({Key? key, required this.product}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildProductImage(),
          _buildProductInfo(),
        ],
      ),
    );
  }
  
  Widget _buildProductImage() {
    return Image.network(
      product.imageUrl,
      height: 200,
      fit: BoxFit.cover,
    );
  }
  
  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: const TextStyle(fontSize: 18)),
          Text('\$${product.price}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
```

## State Management

### Choosing State Management Solution
- **setState**: Simple, local widget state
- **Provider**: Medium complexity apps, dependency injection
- **Bloc/Cubit**: Complex apps, predictable state management
- **Riverpod**: Modern alternative to Provider with better testing support

### Bloc Pattern Implementation
```dart
// Event
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const LoginRequested({required this.email, required this.password});
  
  @override
  List<Object> get props => [email, password];
}

// State
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final User user;
  
  const AuthSuccess({required this.user});
  
  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  
  const AuthFailure({required this.message});
  
  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
```

### State Management Best Practices
- Keep business logic out of widgets
- Use immutable state objects
- Implement proper error states
- Handle loading states appropriately

## Error Handling

### Exception Hierarchy
```dart
// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException({required this.message, this.code});
  
  @override
  String toString() => 'AppException: $message';
}

// Specific exceptions
class NetworkException extends AppException {
  const NetworkException({required String message, String? code})
      : super(message: message, code: code);
}

class ValidationException extends AppException {
  const ValidationException({required String message})
      : super(message: message);
}

class ServerException extends AppException {
  final int statusCode;
  
  const ServerException({
    required String message,
    required this.statusCode,
    String? code,
  }) : super(message: message, code: code);
}
```

### Error Handling in Repository
```dart
class UserRepository {
  final ApiService _apiService;
  
  UserRepository({required ApiService apiService}) : _apiService = apiService;
  
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final response = await _apiService.get('/users/$id');
      final user = User.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
  
  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode ?? 0,
        );
      default:
        return NetworkFailure(message: 'Network error occurred');
    }
  }
}
```

### Global Error Handling
```dart
class GlobalErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log error
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    
    // Report to crash analytics (Firebase Crashlytics, Sentry, etc.)
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // Show user-friendly error message
    if (error is AppException) {
      _showErrorDialog(error.message);
    } else {
      _showErrorDialog('An unexpected error occurred');
    }
  }
  
  static void _showErrorDialog(String message) {
    // Implementation to show error dialog
  }
}

// In main.dart
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    GlobalErrorHandler.handleError(details.exception, details.stack!);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    GlobalErrorHandler.handleError(error, stack);
    return true;
  };
  
  runApp(MyApp());
}
```

## Testing

### Testing Structure
```
test/
├── unit_tests/
│   ├── models/
│   ├── repositories/
│   ├── services/
│   └── utils/
├── widget_tests/
│   ├── screens/
│   └── widgets/
└── integration_tests/
    └── app_test.dart
```

### Unit Testing Example
```dart
// test/unit_tests/repositories/user_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late UserRepository userRepository;
  late MockApiService mockApiService;
  
  setUp(() {
    mockApiService = MockApiService();
    userRepository = UserRepository(apiService: mockApiService);
  });
  
  group('UserRepository', () {
    test('should return User when API call is successful', () async {
      // Arrange
      const userId = '123';
      final userJson = {'id': userId, 'name': 'John Doe'};
      when(mockApiService.get('/users/$userId'))
          .thenAnswer((_) async => Response(data: userJson));
      
      // Act
      final result = await userRepository.getUserById(userId);
      
      // Assert
      expect(result, isA<Right<Failure, User>>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (user) => expect(user.id, equals(userId)),
      );
    });
    
    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const userId = '123';
      when(mockApiService.get('/users/$userId'))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/users/$userId'),
            type: DioExceptionType.connectionTimeout,
          ));
      
      // Act
      final result = await userRepository.getUserById(userId);
      
      // Assert
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (user) => fail('Expected Left but got Right'),
      );
    });
  });
}
```

### Widget Testing Example
```dart
// test/widget_tests/widgets/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('should display correct text', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Click Me';
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Click Me',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(CustomButton));
      
      // Assert
      expect(wasPressed, isTrue);
    });
  });
}
```

### Integration Testing
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('complete user flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login screen
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Enter credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      
      // Submit form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      
      // Verify successful login
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

## Documentation

### Code Documentation
Use meaningful comments and documentation:

```dart
/// A service responsible for handling user authentication operations.
/// 
/// This service provides methods for login, logout, and user session management.
/// It integrates with the backend API and local storage for token persistence.
class AuthService {
  final ApiService _apiService;
  final LocalStorage _localStorage;
  
  /// Creates an instance of [AuthService].
  /// 
  /// Requires [apiService] for network operations and [localStorage] 
  /// for token persistence.
  AuthService({
    required ApiService apiService,
    required LocalStorage localStorage,
  }) : _apiService = apiService, _localStorage = localStorage;
  
  /// Authenticates a user with email and password.
  /// 
  /// Returns a [User] object on successful authentication.
  /// Throws [AuthenticationException] if credentials are invalid.
  /// Throws [NetworkException] if network request fails.
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await authService.login('user@example.com', 'password');
  ///   print('Welcome ${user.name}!');
  /// } catch (e) {
  ///   print('Login failed: $e');
  /// }
  /// ```
  Future<User> login(String email, String password) async {
    // Implementation
  }
}
```

### README Structure
```markdown
# Project Name

Brief description of the project.

## Features
- Feature 1
- Feature 2
- Feature 3

## Getting Started

### Prerequisites
- Flutter SDK (version X.X.X)
- Dart SDK (version X.X.X)
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Configure environment variables
4. Run `flutter run`

### Environment Configuration
Create a `.env` file in the root directory:
```
API_BASE_URL=https://api.example.com
API_KEY=your_api_key_here
```

## Architecture
Brief description of the app architecture (Clean Architecture, MVVM, etc.)

## State Management
Explanation of the state management solution used.

## Testing
- Run unit tests: `flutter test`
- Run integration tests: `flutter test integration_test`

## Contributing
Guidelines for contributing to the project.
```

## Performance

### Widget Performance
- Use `const` constructors wherever possible
- Implement `RepaintBoundary` for expensive widgets
- Use `ListView.builder` for large lists
- Avoid rebuilding entire widget trees

```dart
✅ Good - Using const and RepaintBoundary
class PerformantWidget extends StatelessWidget {
  const PerformantWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: const ExpensiveAnimatedWidget(),
    );
  }
}
```

### Memory Management
- Dispose controllers and streams properly
- Use weak references when appropriate
- Avoid memory leaks in callbacks

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _subscription = someStream.listen((data) {
      // Handle data
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

## Security

### API Security
- Never store sensitive data in plain text
- Use secure storage for tokens and credentials
- Implement certificate pinning for production
- Validate all user inputs

```dart
class SecureApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  
  SecureApiService() : 
    _dio = Dio(),
    _secureStorage = const FlutterSecureStorage() {
    
    // Add interceptors for authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }
  
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }
}
```

### Input Validation
```dart
class ValidationUtils {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return 'Password must contain uppercase, lowercase, and numeric characters';
    }
    
    return null;
  }
}
```

## Conclusion

Following these best practices will help you build maintainable, scalable, and robust Flutter applications. Remember to:

- Consistency is key - establish conventions and stick to them
- Write tests for critical functionality
- Keep widgets small and focused
- Handle errors gracefully
- Document your code appropriately
- Regularly review and refactor your codebase
- Stay updated with Flutter best practices and new features

This document should be treated as a living guide that evolves with your project and team needs.