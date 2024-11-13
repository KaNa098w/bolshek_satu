import 'package:flutter/material.dart';

class ThemeColors {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.yellow,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ThemeColors.orange,
        unselectedItemColor: Colors.black54,
      ),
    );
  }

  static const orange = Color(0xFFFBBE45);
  static Color? grey2 = Colors.grey[300];
  static Color grey = Colors.grey;
  static Color white = Colors.white;
}
