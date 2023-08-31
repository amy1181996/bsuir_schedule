import 'dart:ui';

import 'package:flutter/material.dart';

class GroupCardStyle extends ThemeExtension<GroupCardStyle> {
  final double borderRadius;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color backgroundColor;

  const GroupCardStyle({
    this.borderRadius = 20,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.bold,
    ),
    this.subtitleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    this.backgroundColor = Colors.white,
  });

  @override
  GroupCardStyle copyWith({
    double? borderRadius,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? backgroundColor,
    IconThemeData? iconTheme,
  }) =>
      GroupCardStyle(
        borderRadius: borderRadius ?? this.borderRadius,
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  @override
  GroupCardStyle lerp(ThemeExtension<GroupCardStyle>? other, double t) {
    if (other is! GroupCardStyle) {
      return this;
    }

    return GroupCardStyle(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }
}
