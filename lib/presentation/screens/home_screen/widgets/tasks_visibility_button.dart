import 'package:app/core/constants.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/presentation/screens/home_screen/home_screen.dart';
import 'package:app/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksVisibilityButton extends StatelessWidget {
  const TasksVisibilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = HomeScreen.of(context).tasksCubit;
    return IconButton(
      onPressed: () {
        tasksCubit.toggleShowDoneTasks();
        HomeScreen.of(context).scrollController.animateTo(
              0,
              duration: appTopBarAnimationDuration,
              curve: appCurve,
            );
      },
      icon: BlocBuilder<TasksCubit, TasksState>(
        bloc: tasksCubit,
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              key: UniqueKey(),
              state.showDoneTasks ? Icons.visibility_off : Icons.visibility,
              color: context.appColors.blue,
            ),
          );
        },
      ),
    );
  }
}
