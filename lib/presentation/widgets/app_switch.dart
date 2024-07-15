import 'package:app/core/extensions/app_theme.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: context.appColors.blue,
      inactiveTrackColor: context.appColors.backPrimary,
      trackOutlineColor: WidgetStateColor.resolveWith(
        (_) => context.appColors.supportSeparator,
      ),
      trackOutlineWidth: WidgetStateProperty.resolveWith(
        (_) => 1.0,
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
