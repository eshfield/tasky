import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String formateDate(DateTime dateTime) {
    return DateFormat(
      'd MMMM yyyy',
      Localizations.localeOf(this).languageCode,
    ).format(dateTime);
  }
}
