import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/helpers/connectivity_wrapper.dart';
import 'package:flutter_template/presentation/home/home_screen.dart';

class AppRouter {
  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();

  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String errorRoute = '/error';

  static Route<dynamic> generateRoute(RouteSettings settings) {
     switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => ConnectivityWrapper(child: LoginScreen()),
        );
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case errorRoute:
        return MaterialPageRoute(
          builder: (_) => ErrorScreen(
            routeName: settings.name ?? 'Unknown',
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
    }
  }

  // Global logout function that can be called from anywhere
  // static void logout() {
  //   navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //     loginRoute,
  //     (route) => false,
  //   );
  // }
}

// Extension methods for navigation
extension NavigatorExtension on NavigatorState {
  void navigateToHome() {
    pushReplacementNamed(AppRouter.homeRoute);
  }

  void navigateToProfile() {
    pushNamed(AppRouter.profileRoute);
  }

  void navigateToSettings() {
    pushNamed(AppRouter.settingsRoute);
  }

  void navigateToError(String routeName) {
    pushNamed(AppRouter.errorRoute);
  }

  void logout() {
    pushNamedAndRemoveUntil(
      AppRouter.loginRoute,
      (route) => false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Login Screen')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Profile Screen')));
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Settings Screen')));
  }
}

class ErrorScreen extends StatelessWidget {
  final String routeName;

  const ErrorScreen({
    super.key,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Route Not Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The route "$routeName" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.of(context).navigateToHome(),
              child: Text('Go to Home'),
            ),
            SizedBox(height: 10),
            // TextButton(
            //   onPressed: () => AppRouter.logout(),
            //   child: Text('Logout'),
            // ),
          ],
        ),
      ),
    );
  }
}