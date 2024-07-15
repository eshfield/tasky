import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/extensions/app_theme.dart';
import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String? title;
  final String? text;
  final VoidCallback? onPressed;

  const AppError({
    super.key,
    this.title,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? context.l10n.loadingError,
              style: context.appTextStyles.title.copyWith(
                color: context.appColors.labelPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              text ?? context.l10n.loadingErrorText,
              style: context.appTextStyles.body.copyWith(
                color: context.appColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onPressed != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.replay_rounded,
                    color: context.appColors.blue,
                    size: 48,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
