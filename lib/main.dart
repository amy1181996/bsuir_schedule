import 'package:bsuir_schedule/app_theme/app_theme.dart';
import 'package:bsuir_schedule/navigation/navigation.dart';
import 'package:flutter/material.dart';

void main() {
  final mainNavigation = MainNavigation();

  runApp(
    MaterialApp(
      title: 'BSUIR Schedule',
      theme: AppTheme.light,
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    ),
  );
}
