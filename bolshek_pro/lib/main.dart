import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Добавляем Provider
import 'app/pages/settings/settings_page.dart';
import 'app/widgets/main_controller.dart';
import 'core/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()), // Добавляем AuthProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeColors.lightTheme,
        home: LoginPage(), // Начальный экран
      ),
    );
  }
}
