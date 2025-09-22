import 'package:flutter/material.dart';

import '../../features/user/user_repository.dart';
import '../network/api_client.dart';
import 'service_locator.dart';

class AppDependencies {
  // Global navigation key for handling unauthorized access
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize API Client
    final apiClient = ApiClient(
      onUnauthorized: _handleUnauthorized,
      onClearUserDetails: _handleClearUserDetails,
    );

    // Register services
    sl.register<ApiClient>(apiClient);
    
    // Register repositories
    sl.register<UserRepository>(UserRepository(sl.get<ApiClient>()));

    _initialized = true;
  }

  static bool get isInitialized => _initialized;

  static void reset() {
    _initialized = false;
    sl.clear();
  }

  static void _handleUnauthorized() {
    // Navigate to login screen using global navigator key
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }

  static Future<void> _handleClearUserDetails() async {
    // Clear cookies
    sl.get<ApiClient>().clearCookies();
    
    // Clear any other user session data here
    // Example: SharedPreferences, secure storage, etc.
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
  }
}