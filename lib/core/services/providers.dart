import 'package:flutter_template/core/services/connectivity_service.dart';
import 'package:flutter_template/core/services/theme_service.dart';
import 'package:provider/provider.dart';

final providers = [
  // Add your providers here
  ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
  ChangeNotifierProvider<ConnectivityService>(create: (_) => ConnectivityService()),
];