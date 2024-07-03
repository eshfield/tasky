import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:app/presentation/widgets/app_error.dart';
import 'package:app/presentation/widgets/app_loader.dart';
import 'package:flutter/material.dart';

class AppInitStatusScreen extends StatelessWidget {
  final bool isError;

  const AppInitStatusScreen({super.key, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backPrimary,
      body: SafeArea(
        child: isError
            ? AppError(
                title: context.l10n.initErrorTitle,
                text: context.l10n.initErrorText,
              )
            : const AppLoader(),
      ),
    );
  }
}
