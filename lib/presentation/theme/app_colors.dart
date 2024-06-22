import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color supportSeparator;
  final Color supportOverlay;
  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color labelDisable;
  final Color red;
  final Color green;
  final Color blue;
  final Color gray;
  final Color grayLight;
  final Color white;
  final Color backPrimary;
  final Color backSecondary;
  final Color backElevated;

  const AppColors({
    required this.supportSeparator,
    required this.supportOverlay,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelDisable,
    required this.red,
    required this.green,
    required this.blue,
    required this.gray,
    required this.grayLight,
    required this.white,
    required this.backPrimary,
    required this.backSecondary,
    required this.backElevated,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? supportSeparator,
    Color? supportOverlay,
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? labelDisable,
    Color? red,
    Color? green,
    Color? blue,
    Color? gray,
    Color? grayLight,
    Color? white,
    Color? backPrimary,
    Color? backSecondary,
    Color? backElevated,
  }) {
    return AppColors(
      supportSeparator: supportSeparator ?? this.supportSeparator,
      supportOverlay: supportOverlay ?? this.supportOverlay,
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      labelDisable: labelDisable ?? this.labelDisable,
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      gray: gray ?? this.gray,
      grayLight: grayLight ?? this.grayLight,
      white: white ?? this.white,
      backPrimary: backPrimary ?? this.backPrimary,
      backSecondary: backSecondary ?? this.backSecondary,
      backElevated: backElevated ?? this.backElevated,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) return this;
    return AppColors(
      supportSeparator:
          Color.lerp(supportSeparator, other.supportSeparator, t)!,
      supportOverlay: Color.lerp(supportOverlay, other.supportOverlay, t)!,
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t)!,
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t)!,
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t)!,
      labelDisable: Color.lerp(labelDisable, other.labelDisable, t)!,
      red: Color.lerp(red, other.red, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      grayLight: Color.lerp(grayLight, other.grayLight, t)!,
      white: Color.lerp(white, other.white, t)!,
      backPrimary: Color.lerp(backPrimary, other.backPrimary, t)!,
      backSecondary: Color.lerp(backSecondary, other.backSecondary, t)!,
      backElevated: Color.lerp(backElevated, other.backElevated, t)!,
    );
  }
}
