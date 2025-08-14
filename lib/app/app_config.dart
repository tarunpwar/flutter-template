import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment {
  dev,
  staging,
  prod,
}

class AppConfig {
  static Environment _environment = Environment.dev;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  // Load environment-specific .env file
  static Future<void> loadEnvFile() async {
    String envFile;
    switch (_environment) {
      case Environment.dev:
        envFile = '.env.dev';
        break;
      case Environment.staging:
        envFile = '.env.staging';
        break;
      case Environment.prod:
        envFile = '.env.prod';
        break;
    }
    
    try {
      await dotenv.load(fileName: envFile);
      debugPrint('Loaded environment file: $envFile');
    } catch (e) {
      debugPrint('Error loading $envFile: $e');
      // Fallback to default .env file
      try {
        await dotenv.load();
        debugPrint('Loaded default .env file');
      } catch (e) {
        debugPrint('Error loading default .env file: $e');
      }
    }
  }
  
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.yourapp.com';
  
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  static String get databaseUrl => dotenv.env['DATABASE_URL'] ?? '';
  
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  
  static String get appName => dotenv.env['APP_NAME'] ?? 'YourApp';
  
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';
  
  static bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  
  static String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  
  static String get stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  
  static String get oneSignalAppId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';
  
  // Get any environment variable
  static String getEnv(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }
  
  // Check if we're in debug mode
  static bool get isDebug => enableLogging && (_environment == Environment.dev || _environment == Environment.staging);
}

// lib/main_dev.dart
// void main() {
//   AppConfig.setEnvironment(Environment.dev);
//   runApp(MyApp());
// }

// lib/main_staging.dart
// void main() {
//   AppConfig.setEnvironment(Environment.staging);
//   runApp(MyApp());
// }

// lib/main_prod.dart
// void main() {
//   AppConfig.setEnvironment(Environment.prod);
//   runApp(MyApp());
// }

// Running Different Environments:
// # Development
// flutter run -t lib/main_dev.dart --flavor dev

// # Staging  
// flutter run -t lib/main_staging.dart --flavor staging

// # Production
// flutter run -t lib/main_prod.dart --flavor prod --release

// Building for Different Environments:
// # Development APK
// flutter build apk -t lib/main_dev.dart --flavor dev

// # Staging APK
// flutter build apk -t lib/main_staging.dart --flavor staging

// # Production APK
// flutter build apk -t lib/main_prod.dart --flavor prod