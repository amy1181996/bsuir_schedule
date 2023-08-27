import 'package:flutter/material.dart';

class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  const AppTextTheme({
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.bold,
    ),
    this.bodyStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  });

  @override
  AppTextTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? bodyStyle,
  }) =>
      AppTextTheme(
        titleStyle: titleStyle ?? this.titleStyle,
        bodyStyle: bodyStyle ?? this.bodyStyle,
      );

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) {
      return this;
    }

    return AppTextTheme(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
    );
  }
}
