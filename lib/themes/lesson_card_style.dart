import 'dart:ui';

import 'package:flutter/material.dart';

class LessonCardStyle extends ThemeExtension<LessonCardStyle> {
  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final TextStyle secondayBodyStyle;
  final double borderRadius;

  const LessonCardStyle({
    this.backgroundColor = Colors.white,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.bold,
    ),
    this.bodyStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    this.secondayBodyStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
    this.borderRadius = 20,
  });

  @override
  LessonCardStyle copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? bodyStyle,
    TextStyle? secondayBodyStyle,
    double? borderRadius,
  }) =>
      LessonCardStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        titleStyle: titleStyle ?? this.titleStyle,
        bodyStyle: bodyStyle ?? this.bodyStyle,
        secondayBodyStyle: secondayBodyStyle ?? this.secondayBodyStyle,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  @override
  LessonCardStyle lerp(ThemeExtension<LessonCardStyle>? other, double t) {
    if (other is! LessonCardStyle) {
      return this;
    }

    return LessonCardStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
    );
  }
}
