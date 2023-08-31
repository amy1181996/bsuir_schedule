import 'package:flutter/material.dart';

class LessonBottomSheetStyle extends ThemeExtension<LessonBottomSheetStyle> {
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final EdgeInsets padding;
  final Color cardColor;

  const LessonBottomSheetStyle({
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.bold,
    ),
    this.bodyStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    this.cardColor = Colors.white,
  });

  @override
  LessonBottomSheetStyle copyWith({
    TextStyle? titleStyle,
    TextStyle? bodyStyle,
    EdgeInsets? padding,
    Color? cardColor,
  }) =>
      LessonBottomSheetStyle(
        titleStyle: titleStyle ?? this.titleStyle,
        bodyStyle: bodyStyle ?? this.bodyStyle,
        padding: padding ?? this.padding,
        cardColor: cardColor ?? this.cardColor,
      );

  @override
  LessonBottomSheetStyle lerp(
      ThemeExtension<LessonBottomSheetStyle>? other, double t) {
    if (other is! LessonBottomSheetStyle) {
      return this;
    }

    return LessonBottomSheetStyle(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
    );
  }
}
