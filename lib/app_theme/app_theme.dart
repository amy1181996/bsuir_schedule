import 'package:flutter/material.dart';

abstract class AppTheme {
  static final dark = ThemeData(
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
    ),
  );

  static final light = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey,
  );
}
