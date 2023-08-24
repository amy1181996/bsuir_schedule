import 'package:bsuir_schedule/ui/navigation/navigation.dart';
import 'package:bsuir_schedule/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MaterialApp(
      title: 'BSUIR Schedule',
      theme: AppTheme.dark,
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
