import 'package:flutter/material.dart';

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle titleLarge;
  final TextStyle title;
  final TextStyle body;
  final TextStyle subhead;

  const AppTextStyles({
    required this.titleLarge,
    required this.title,
    required this.body,
    required this.subhead,
  });

  @override
  ThemeExtension<AppTextStyles> copyWith({
    TextStyle? titleLarge,
    TextStyle? title,
    TextStyle? body,
    TextStyle? subhead,
  }) {
    return AppTextStyles(
      titleLarge: titleLarge ?? this.titleLarge,
      title: title ?? this.title,
      body: body ?? this.body,
      subhead: subhead ?? this.subhead,
    );
  }

  @override
  ThemeExtension<AppTextStyles> lerp(
    covariant ThemeExtension<AppTextStyles>? other,
    double t,
  ) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      subhead: TextStyle.lerp(subhead, other.subhead, t)!,
    );
  }
}
