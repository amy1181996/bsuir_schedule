import 'package:flutter/material.dart';

class LessonTimeBarStyle extends ThemeExtension<LessonTimeBarStyle> {
  final Color backgroundColor;
  final TextStyle textStyle;

  const LessonTimeBarStyle({
    this.backgroundColor = Colors.blue,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16,),
  });

  @override
  ThemeExtension<LessonTimeBarStyle> copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
  }) =>
      LessonTimeBarStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        textStyle: textStyle ?? this.textStyle,
      );

  @override
  ThemeExtension<LessonTimeBarStyle> lerp(ThemeExtension<LessonTimeBarStyle>? other, double t) {
    if (other is! LessonTimeBarStyle) {
      return this;
    }

    return LessonTimeBarStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }
}