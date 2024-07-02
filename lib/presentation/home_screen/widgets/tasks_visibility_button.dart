import 'package:app/constants.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class TasksVisibilityButton extends StatelessWidget {
  const TasksVisibilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = GetIt.I<TasksCubit>();
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
        bloc: GetIt.I<TasksCubit>(),
        builder: (context, state) {
          return Icon(
            state.showDoneTasks ? Icons.visibility_off : Icons.visibility,
            color: context.appColors.blue,
          );
        },
      ),
    );
  }
}
