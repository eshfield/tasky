import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final VoidCallback onPressed;

  const AppError({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.loadingError,
              style: context.appTextStyles.title.copyWith(
                color: context.appColors.labelPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.loadingErrorText,
              style: context.appTextStyles.body.copyWith(
                color: context.appColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.replay_rounded,
                color: context.appColors.blue,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
