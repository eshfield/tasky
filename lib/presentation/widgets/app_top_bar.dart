import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

const buttonPadding = 16.0 - (48.0 - 24.0) / 2;

class AppTopBar extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;

  const AppTopBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? context.appColors.backSecondary
              : context.appColors.backPrimary,
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(left: buttonPadding),
                child: leading!,
              ),
            if (title != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    title!,
                    style: context.appTextStyles.title.copyWith(
                      color: context.appColors.labelPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: buttonPadding),
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
