import 'package:flutter/material.dart';

class SettingsTheme extends ThemeExtension<SettingsTheme> {
  final Color scaffoldColor;
  final Color menuColor;

  const SettingsTheme({
    this.scaffoldColor = Colors.white,
    this.menuColor = Colors.grey,
  });

  @override
  SettingsTheme copyWith({
    Color? scaffoldColor,
    Color? menuColor,
  }) =>
      SettingsTheme(
        scaffoldColor: scaffoldColor ?? this.scaffoldColor,
        menuColor: menuColor ?? this.menuColor,
      );

  @override
  SettingsTheme lerp(ThemeExtension<SettingsTheme>? other, double t) {
    if (other is! SettingsTheme) {
      return this;
    }

    return SettingsTheme(
      scaffoldColor: Color.lerp(scaffoldColor, other.scaffoldColor, t)!,
      menuColor: Color.lerp(menuColor, other.menuColor, t)!,
    );
  }
}
