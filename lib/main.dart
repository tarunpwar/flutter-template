import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';

import 'core/services/storage_service.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize services
 await StorageService.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}
