import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/home_screen/widgets/done_tasks_visibility_button.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 124,
      padding: const EdgeInsets.only(left: 60, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appTitle,
            style: context.appTextStyles.titleLarge.copyWith(
              color: context.appColors.labelPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.tasksDone(HomeScreen.doneTaskCountOf(context)),
                  style: context.appTextStyles.body.copyWith(
                    color: context.appColors.labelTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              const DoneTasksVisibilityButton(),
            ],
          ),
        ],
      ),
    );
  }
}
