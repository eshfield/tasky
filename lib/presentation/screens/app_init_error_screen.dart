import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/extensions/app_theme.dart';
import 'package:app/presentation/widgets/app_error.dart';
import 'package:flutter/material.dart';

class AppInitErrorScreen extends StatelessWidget {
  const AppInitErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backPrimary,
      body: SafeArea(
        child: AppError(
          title: context.l10n.initErrorTitle,
          text: context.l10n.initErrorText,
        ),
      ),
    );
  }
}
