import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class AppDropdownMenu<T> extends StatelessWidget {
  final T initialSelection;
  final Color textColor;
  final void Function(T?) onSelected;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  const AppDropdownMenu({
    super.key,
    required this.initialSelection,
    required this.textColor,
    required this.onSelected,
    required this.dropdownMenuEntries,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: context.appColors.supportSeparator),
    );
    return DropdownMenu(
      expandedInsets: EdgeInsets.zero,
      initialSelection: initialSelection,
      inputDecorationTheme: InputDecorationTheme(
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: context.appColors.backSecondary,
      ),
      textStyle: context.appTextStyles.body.copyWith(color: textColor),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateColor.resolveWith(
          (_) => context.appColors.backSecondary,
        ),
      ),
      onSelected: onSelected,
      dropdownMenuEntries: dropdownMenuEntries,
    );
  }
}
