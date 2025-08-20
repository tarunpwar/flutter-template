import 'package:flutter/material.dart';
import 'package:flutter_template/app/theme/app_theme.dart';
import 'package:flutter_template/core/di/app_dependencies.dart';
import 'package:flutter_template/core/services/theme_service.dart';
import 'package:provider/provider.dart';

import 'routes/route_generator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (_, theme, _) => MaterialApp(
        title: 'Flutter Template',
        navigatorKey: AppDependencies.navigatorKey,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.themeMode,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.homeRoute,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
