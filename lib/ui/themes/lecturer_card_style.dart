import 'dart:ui';

import 'package:flutter/material.dart';

class LecturerCardStyle extends ThemeExtension<LecturerCardStyle> {
  final double borderRadius;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color backgroundColor;

  const LecturerCardStyle({
    this.borderRadius = 20,
    this.titleStyle = const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    this.subtitleStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    this.backgroundColor = Colors.white,
  });

  @override
  LecturerCardStyle copyWith({
    double? borderRadius,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? backgroundColor,
  }) =>
      LecturerCardStyle(
        borderRadius: borderRadius ?? this.borderRadius,
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  @override
  LecturerCardStyle lerp(ThemeExtension<LecturerCardStyle>? other, double t) {
    if (other is! LecturerCardStyle) {
      return this;
    }

    return LecturerCardStyle(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }
}
