import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/core/di/service_locator.dart';
import 'package:flutter_template/presentation/user/user_view_model.dart';
import 'package:provider/provider.dart';

import 'core/di/app_dependencies.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/theme_service.dart';
import 'features/user/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize services
  await StorageService.instance.init();
  // Initialize dependencies
  await AppDependencies.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        Provider<UserViewModel>(
          create: (_) => UserViewModel(sl.get<UserRepository>()),
        ),
      ],
      child: MyApp(),
    );
  }
}
