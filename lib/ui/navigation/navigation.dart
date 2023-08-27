import 'package:bsuir_schedule/ui/screen_factory/screen_factory.dart';
import 'package:flutter/material.dart';

abstract class NavigationRoutes {
  static const root = '/';
  static const settings = '/settings';
}

class MainNavigation {
  final _screenFactory = ScreenFactory();

  Map<String, WidgetBuilder> get routes => {
        NavigationRoutes.root: (_) => _screenFactory.makeRootScreen(),
        NavigationRoutes.settings: (_) => _screenFactory.makeSettingsScreen(),
      };

  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    return null;
  }
}
