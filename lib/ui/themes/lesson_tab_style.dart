import 'package:flutter/material.dart';

class LessonTabStyle extends ThemeExtension<LessonTabStyle> {
  final TextStyle weekdayStyle;
  final TextStyle dateStyle;

  const LessonTabStyle({
    this.weekdayStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.dateStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  });

  @override
  LessonTabStyle copyWith({
    TextStyle? weekdayStyle,
    TextStyle? dateStyle,
  }) =>
      LessonTabStyle(
        weekdayStyle: weekdayStyle ?? this.weekdayStyle,
        dateStyle: dateStyle ?? this.dateStyle,
      );

  @override
  LessonTabStyle lerp(ThemeExtension<LessonTabStyle>? other, double t) {
    if (other is! LessonTabStyle) {
      return this;
    }

    return LessonTabStyle(
      weekdayStyle: TextStyle.lerp(weekdayStyle, other.weekdayStyle, t)!,
      dateStyle: TextStyle.lerp(dateStyle, other.dateStyle, t)!,
    );
  }
}
