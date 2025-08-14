import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'storage_service.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }
  
  bool get isLightMode {
    return _themeMode == ThemeMode.light;
  }
  
  bool get isSystemMode {
    return _themeMode == ThemeMode.system;
  }

  ThemeService() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final savedThemeMode = StorageService.instance.getString(AppConstants.themeMode);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await StorageService.instance.setString(
      AppConstants.themeMode,
      themeMode.toString(),
    );
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newThemeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newThemeMode);
  }
}