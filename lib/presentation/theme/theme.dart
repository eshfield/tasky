import 'package:app/presentation/theme/app_colors.dart';
import 'package:app/presentation/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final _base = ThemeData(
    fontFamily: 'Roboto',
    colorSchemeSeed: _lightAppColors.blue,
  );

  static final light = _base.copyWith(
    brightness: Brightness.light,
    extensions: const [
      _lightAppColors,
      _appTextStyles,
    ],
  );

  static final dark = _base.copyWith(
    brightness: Brightness.dark,
    extensions: const [
      _darkAppColors,
      _appTextStyles,
    ],
  );

  static const _lightAppColors = AppColors(
    supportSeparator: Color(0x33000000),
    supportOverlay: Color(0x0F000000),
    labelPrimary: Color(0xFF000000),
    labelSecondary: Color(0x99000000),
    labelTertiary: Color(0x4D000000),
    labelDisable: Color(0x26000000),
    red: Color(0xFFFF3B30),
    green: Color(0xFF34C759),
    blue: Color(0xFF007AFF),
    gray: Color(0xFF8E8E93),
    grayLight: Color(0xFFD1D1D6),
    white: Color(0xFFFFFFFF),
    backPrimary: Color(0xFFF7F6F2),
    backSecondary: Color(0xFFFFFFFF),
    backElevated: Color(0xFFFFFFFF),
  );

  static const _darkAppColors = AppColors(
    supportSeparator: Color(0x33FFFFFF),
    supportOverlay: Color(0x52000000),
    labelPrimary: Color(0xFFFFFFFF),
    labelSecondary: Color(0x99FFFFFF),
    labelTertiary: Color(0x66FFFFFF),
    labelDisable: Color(0x26FFFFFF),
    red: Color(0xFFFF453A),
    green: Color(0xFF32D74B),
    blue: Color(0xFF0A84FF),
    gray: Color(0xFF8E8E93),
    grayLight: Color(0xFF48484A),
    white: Color(0xFFFFFFFF),
    backPrimary: Color(0xFF161618),
    backSecondary: Color(0xFF252528),
    backElevated: Color(0xFF3C3C3F),
  );

  static const _appTextStyles = AppTextStyles(
    titleLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      height: 38 / 32,
    ),
    title: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 32 / 20,
    ),
    body: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 20 / 16,
    ),
    subhead: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    ),
  );
}
