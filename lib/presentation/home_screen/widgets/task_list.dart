import 'package:app/domain/models/task.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/home_screen/widgets/task_list_tile.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList(this.tasks, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: context.appColors.backSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.supportOverlay),
        ),
        sliver: SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          sliver: SliverList.builder(
            itemCount: tasks.length + 1,
            itemBuilder: (_, index) {
              return index != tasks.length
                  ? TaskListTile(tasks[index])
                  : const _CreateTaskButton();
            },
          ),
        ),
      ),
    );
  }
}

class _CreateTaskButton extends StatelessWidget {
  const _CreateTaskButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.appColors.supportOverlay,
          ),
        ),
      ),
      child: TextButton(
        onPressed: HomeScreen.of(context).openTaskScreen,
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              context.l10n.createTask,
              style: context.appTextStyles.body.copyWith(
                color: context.appColors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
