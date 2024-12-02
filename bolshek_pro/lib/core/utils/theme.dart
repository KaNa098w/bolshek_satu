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
  static const transparent = Color(0x00000000);
  static const grey3 = Color(0xFFBDBDBD);
  static const grey4 = Color(0xFFd9d9d9);
  static const grey5 = Color(0xFF4F4F4F);
  static const grey6 = Color(0xFF9A9DA4);
  static const grey7 = Color(0xFFE7E7E9);
  static const grey8 = Color(0xFF888B93);
  static const grey9 = Color(0xFFE8E7E7);
  static const black = Colors.black;
  static const blackWithPath = Color.fromARGB(255, 53, 52, 52);
  static const grey10 = Color(0xFFE7E7E9);
  static const red = Color.fromARGB(255, 218, 102, 94);

  static const green1 = Colors.green;
  static const green = Color.fromARGB(255, 75, 212, 110);
  static const error = Color(0xFFE2100C);
  static const iBrandPrimary = Color(0xFF2B63F3);
}
