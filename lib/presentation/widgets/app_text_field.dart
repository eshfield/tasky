import 'package:app/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: context.appColors.supportSeparator),
    );
    final cursorColor = context.appColors.labelSecondary;
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      cursorColor: cursorColor,
      cursorErrorColor: cursorColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.appColors.backSecondary,
        errorStyle: context.appTextStyles.subhead,
        border: border,
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: context.appColors.red),
        ),
        enabledBorder: border,
        focusedBorder: border,
        hintText: hintText,
        hintStyle: context.appTextStyles.body.copyWith(
          color: context.appColors.labelTertiary,
        ),
      ),
      minLines: minLines,
      maxLines: maxLines,
      style: context.appTextStyles.body.copyWith(
        color: context.appColors.labelPrimary,
      ),
      textCapitalization: TextCapitalization.sentences,
      validator: validator,
    );
  }
}
