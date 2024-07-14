import 'package:app/domain/entities/task.dart';
import 'package:app/core/extensions/l10n_extension.dart';
import 'package:app/presentation/screens/home_screen/widgets/auto_animated_sliver_list.dart';
import 'package:app/presentation/screens/home_screen/widgets/task_list_tile.dart';
import 'package:app/core/extensions/app_theme_extension.dart';
import 'package:app/core/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TasksList extends StatelessWidget {
  final List<Task> tasks;

  const TasksList(this.tasks, {super.key});

  @override
  Widget build(BuildContext context) {
    return TaskListInheritedWidget(
      tasks,
      child: SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: context.appColors.backSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.appColors.supportOverlay),
          ),
          sliver: const SliverMainAxisGroup(
            slivers: [
              _TasksList(),
              _CreateTaskButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskListInheritedWidget extends InheritedWidget {
  final List<Task> tasks;

  const TaskListInheritedWidget(
    this.tasks, {
    super.key,
    required super.child,
  });

  static TaskListInheritedWidget of(BuildContext context) =>
      maybeOf(context) ??
      (throw Exception(
          '$TaskListInheritedWidget was not found in the context'));

  static TaskListInheritedWidget? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class _TasksList extends StatelessWidget {
  const _TasksList();

  @override
  Widget build(BuildContext context) {
    final tasks = TaskListInheritedWidget.of(context).tasks;
    return AutoAnimatedSliverList(
      items: tasks,
      idMapper: (item) => item.id,
      itemBuilder: (context, index, animation) {
        final task = tasks[index];
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: TaskListTile(
              task,
              isFirst: index == 0,
              isLast: index == tasks.length,
            ),
          ),
        );
      },
    );
  }
}

class _CreateTaskButton extends StatelessWidget {
  const _CreateTaskButton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.appColors.supportOverlay,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextButton(
          onPressed: () => context.goNamed(AppRoute.task.name),
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
      ),
    );
  }
}
