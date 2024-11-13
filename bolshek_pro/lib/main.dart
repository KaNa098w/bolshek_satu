import 'package:flutter/material.dart';
import 'ui/pages/settings/settings_page.dart';
import 'ui/widgets/main_controller.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeColors.lightTheme,
      home: const MainControllerNavigator(), // Здесь основной экран
    );
  }
}
