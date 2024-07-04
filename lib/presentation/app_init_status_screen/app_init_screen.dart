import 'package:app/domain/bloc/app_init_cubit.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:app/presentation/widgets/app_error.dart';
import 'package:app/presentation/widgets/app_loader.dart';
import 'package:flutter/material.dart';

class AppInitScreen extends StatelessWidget {
  final AppInitStatus status;

  const AppInitScreen(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backPrimary,
      body: SafeArea(
        child: switch (status) {
          AppInitStatus.loading => const AppLoader(),
          AppInitStatus.failure => AppError(
              title: context.l10n.initErrorTitle,
              text: context.l10n.initErrorText,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
