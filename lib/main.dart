import 'package:bsuir_schedule/themes/app_theme.dart';
import 'package:bsuir_schedule/navigation/navigation.dart';
import 'package:flutter/material.dart';

void main() {
  final mainNavigation = MainNavigation();

  runApp(
    MaterialApp(
      title: 'BSUIR Schedule',
      theme: AppTheme.dark,
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    ),
  );
}
