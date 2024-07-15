import 'package:app/core/extensions/app_theme.dart';
import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context, {
  required String text,
  Color? backgroundColor,
}) {
  final snackBar = _AppSnackBar(
    text,
    color: backgroundColor ?? context.appColors.gray,
  );
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(snackBar);
}

class _AppSnackBar extends SnackBar {
  final String text;
  final Color? color;

  _AppSnackBar(this.text, {this.color})
      : super(
          backgroundColor: color,
          content: _Content(text),
        );
}

class _Content extends StatelessWidget {
  final String text;

  const _Content(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: context.appColors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: context.appTextStyles.body.copyWith(
              color: context.appColors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
