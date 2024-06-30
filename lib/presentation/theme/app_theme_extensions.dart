import 'package:app/presentation/theme/app_colors.dart';
import 'package:app/presentation/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

extension AppThemeExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  AppTextStyles get appTextStyles => Theme.of(this).extension<AppTextStyles>()!;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
