import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/themes/group_card_style.dart';
import 'package:bsuir_schedule/ui/themes/lecturer_card_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_bottom_sheet_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_card_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_tab_style.dart';
import 'package:bsuir_schedule/ui/themes/lesson_time_bar_style.dart';
import 'package:bsuir_schedule/ui/themes/settings_theme.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.blue,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.blue)),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        shape: MaterialStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>{
      LessonCardStyle(
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
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        borderRadius: 20,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      LecturerCardStyle(
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        borderRadius: 20,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      LessonBottomSheetStyle(
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cardColor: Color.fromARGB(255, 28, 28, 28),
      ),
      LessonTabStyle(
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
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      SettingsTheme(
        scaffoldColor: Colors.black,
        menuColor: Color.fromARGB(255, 28, 28, 28),
      ),
      LessonTimeBarStyle(
        backgroundColor: Colors.blue,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      )
    },
  );

  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.blue,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.blue,
      ),
      shadowColor: Colors.grey[100]!,
      elevation: 1.0,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color.fromARGB(255, 28, 28, 28),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Color.fromARGB(255, 28, 28, 28),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Color.fromARGB(255, 28, 28, 28),
      backgroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 28, 28, 28),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateColor.resolveWith(
          (states) => const Color.fromARGB(255, 28, 28, 28),
        ),
      ),
    ),
    radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.blue)),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        shape: MaterialStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>{
      LessonCardStyle(
        backgroundColor: Colors.grey[100]!,
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
        secondayBodyStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
      ),
      GroupCardStyle(
        backgroundColor: Colors.grey[100]!,
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
      ),
      LecturerCardStyle(
        backgroundColor: Colors.grey[100]!,
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 15,
        ),
      ),
      LessonBottomSheetStyle(
        cardColor: Colors.grey[200]!,
      ),
      const LessonTabStyle(),
      const AppTextTheme(),
      SettingsTheme(
        scaffoldColor: Colors.grey[400]!,
        menuColor: Colors.white,
      ),
      const LessonTimeBarStyle(
        backgroundColor: Colors.blue,
        textStyle: TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
      ),
    },
  );

  static final _baseDarkMaterial = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
  );

  static final darkMaterial = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: <ThemeExtension<dynamic>>{
      LessonCardStyle(
        backgroundColor: _baseDarkMaterial.colorScheme.secondaryContainer,
        titleStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
        secondayBodyStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 15,
        ),
        borderRadius: 20,
      ),
      GroupCardStyle(
        backgroundColor:  _baseDarkMaterial.colorScheme.secondaryContainer,
        borderRadius: 20,
        titleStyle: TextStyle(
          color:_baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),

      ),
      LecturerCardStyle(
        backgroundColor:  _baseDarkMaterial.colorScheme.secondaryContainer,
        borderRadius: 20,
        titleStyle: TextStyle(
          color:_baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 15,
        ),
      ),
      LessonBottomSheetStyle(
        titleStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
        cardColor:  _baseDarkMaterial.colorScheme.secondaryContainer,
      ),
      LessonTabStyle(
        weekdayStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        dateStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
      ),
      AppTextTheme(
        titleStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color:_baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
      ),
      SettingsTheme(
        scaffoldColor: _baseDarkMaterial.colorScheme.surface,
        menuColor:  _baseDarkMaterial.colorScheme.surface,
      ),
      LessonTimeBarStyle(
        backgroundColor: _baseDarkMaterial.colorScheme.secondaryContainer,
        textStyle: TextStyle(
          color: _baseDarkMaterial.colorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
      )
    },
  );

  static final _baseLightMaterial = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static final lightMaterial = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    extensions: <ThemeExtension<dynamic>>{
      LessonCardStyle(
        backgroundColor: _baseLightMaterial.primaryColor,
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
        secondayBodyStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
      ),
      GroupCardStyle(
        backgroundColor: _baseLightMaterial.primaryColor,
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
      ),
      LecturerCardStyle(
        backgroundColor: _baseLightMaterial.primaryColor,
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        subtitleStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 15,
        ),
      ),
      LessonBottomSheetStyle(
        cardColor: _baseLightMaterial.primaryColor,
      ),
      const LessonTabStyle(),
      const AppTextTheme(),
      SettingsTheme(
        scaffoldColor: Colors.grey[400]!,
        menuColor: _baseLightMaterial.primaryColor,
      ),
      LessonTimeBarStyle(
        backgroundColor: _baseLightMaterial.primaryColor,
        textStyle: const TextStyle(
          color: Color.fromARGB(255, 28, 28, 28),
          fontSize: 16,
        ),
      ),
    },
  );
}
