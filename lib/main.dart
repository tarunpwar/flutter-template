import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/presentation/user/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/theme_service.dart';
import 'dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize services
  await StorageService.instance.init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppDependencies _dependencies;
  @override
  void initState() {
    super.initState();
    _dependencies = AppDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        Provider<UserViewModel>(
          create: (_) => UserViewModel(_dependencies.userRepository),
        ),
      ],
      child: MyApp(),
    );
  }
}
