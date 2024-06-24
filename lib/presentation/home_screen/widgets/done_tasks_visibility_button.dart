import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class DoneTasksVisibilityButton extends StatelessWidget {
  const DoneTasksVisibilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: HomeScreen.of(context).toggleShowDoneTasks,
      icon: Icon(
        HomeScreen.showDoneTasksOf(context)
            ? Icons.visibility_off
            : Icons.visibility,
        color: context.appColors.blue,
      ),
    );
  }
}
