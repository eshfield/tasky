import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  required DateTime? initialDate,
}) async {
  final now = DateTime.now();
  final buttonStyle = TextButton.styleFrom(
    foregroundColor: context.appColors.blue,
  );
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  final dayBackgroundColor =
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return context.appColors.blue;
    }
    return null;
  });
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    firstDate: now,
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: context.appColors.backSecondary,
            cancelButtonStyle: buttonStyle,
            confirmButtonStyle: buttonStyle,
            dividerColor: WidgetStateColor.transparent,
            headerBackgroundColor:
                WidgetStateColor.resolveWith((_) => context.appColors.blue),
            headerForegroundColor:
                WidgetStateColor.resolveWith((_) => context.appColors.white),
            dayBackgroundColor: dayBackgroundColor,
            dayForegroundColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return context.appColors.labelPrimary;
              } else if (states.contains(WidgetState.disabled)) {
                return context.appColors.labelPrimary.withOpacity(0.38);
              }
              return context.appColors.labelPrimary;
            }),
            dayOverlayColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                if (states.contains(WidgetState.pressed)) {
                  return context.appColors.labelPrimary.withOpacity(0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return context.appColors.labelPrimary.withOpacity(0.08);
                }
                if (states.contains(WidgetState.focused)) {
                  return context.appColors.labelPrimary.withOpacity(0.1);
                }
              } else {
                if (states.contains(WidgetState.pressed)) {
                  return context.appColors.white.withOpacity(0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return context.appColors.white.withOpacity(0.08);
                }
                if (states.contains(WidgetState.focused)) {
                  return context.appColors.white.withOpacity(0.1);
                }
              }
              return null;
            }),
            todayBackgroundColor: dayBackgroundColor,
            todayForegroundColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return context.appColors.white;
              } else if (states.contains(WidgetState.disabled)) {
                return context.appColors.blue.withOpacity(0.38);
              }
              return context.appColors.blue;
            }),
            todayBorder: BorderSide(color: context.appColors.blue),
            weekdayStyle: textTheme.bodyLarge?.apply(
              color: context.appColors.labelPrimary,
            ),
            yearBackgroundColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return context.appColors.blue;
              }
              return null;
            }),
            yearForegroundColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return context.appColors.white;
              } else if (states.contains(WidgetState.disabled)) {
                return context.appColors.white.withOpacity(0.38);
              }
              return context.appColors.labelPrimary;
            }),
            yearOverlayColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                if (states.contains(WidgetState.pressed)) {
                  return context.appColors.labelPrimary.withOpacity(0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return context.appColors.labelPrimary.withOpacity(0.08);
                }
                if (states.contains(WidgetState.focused)) {
                  return context.appColors.labelPrimary.withOpacity(0.1);
                }
              } else {
                if (states.contains(WidgetState.pressed)) {
                  return context.appColors.white.withOpacity(0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return context.appColors.white.withOpacity(0.08);
                }
                if (states.contains(WidgetState.focused)) {
                  return context.appColors.white.withOpacity(0.1);
                }
              }
              return null;
            }),
          ),
          colorScheme: colorScheme.copyWith(
            onSurface: context.appColors.labelPrimary,
          ),
        ),
        child: child!,
      );
    },
  );
}
