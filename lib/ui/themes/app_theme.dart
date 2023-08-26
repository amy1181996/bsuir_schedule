import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/themes/group_card_style.dart';
import 'package:bsuir_schedule/ui/themes/lecturer_card_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_bottom_sheet_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_card_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_tab_style.dart';
import 'package:flutter/material.dart';

class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(
      color.value,
      <int, Color>{
        50: color.withOpacity(0.1),
        100: color.withOpacity(0.2),
        200: color.withOpacity(0.3),
        300: color.withOpacity(0.4),
        400: color.withOpacity(0.5),
        500: color.withOpacity(0.6),
        600: color.withOpacity(0.7),
        700: color.withOpacity(0.8),
        800: color.withOpacity(0.9),
        900: color.withOpacity(1.0),
      },
    );
  }
}

abstract class AppTheme {
  static final _darkPrimarySwatch = MaterialColorGenerator.from(
    const Color.fromARGB(255, 28, 28, 28),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color.fromARGB(255, 28, 28, 28),
      background: Color.fromARGB(255, 28, 28, 28),
    ),
    primarySwatch: _darkPrimarySwatch,
    primaryColor: const Color.fromARGB(255, 28, 28, 28),
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.grey,
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>{
      const LessonCardStyle(
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        secondayBodyStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        borderRadius: 20,
      ),
      GroupCardStyle(
        borderRadius: 20,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      LecturerCardStyle(
        borderRadius: 20,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      LessonBottomSheetStyle(
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      const LessonTabStyle(
        weekdayStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        dateStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      AppTextTheme(
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    },
  );

  static final light = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey,
  );
}
