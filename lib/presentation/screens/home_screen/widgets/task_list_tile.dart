import 'package:app/core/di/remote_config.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/extensions/app_theme.dart';
import 'package:app/core/routing.dart';
import 'package:app/presentation/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskListTile extends StatelessWidget {
  final Task task;

  const TaskListTile(
    this.task, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final blocDispatcher = HomeScreen.of(context).blocDispatcher;
    return TaskListTileInheritedWidget(
      task: task,
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: Dismissible(
          key: ValueKey(task.id),
          background: const _Background(),
          secondaryBackground: const _SecondaryBackground(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              blocDispatcher.toggleTaskAsDone(task);
            } else if (direction == DismissDirection.endToStart) {
              blocDispatcher.removeTask(task.id);
            }
            // we don't need built-in dismiss animation since we have own one
            return false;
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MarkAsDoneCheckbox(),
                Expanded(
                  child: _TextLine(),
                ),
                SizedBox(width: 12),
                _EditButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskListTileInheritedWidget extends InheritedWidget {
  final Task task;

  const TaskListTileInheritedWidget({
    super.key,
    required this.task,
    required super.child,
  });

  static TaskListTileInheritedWidget of(BuildContext context) =>
      maybeOf(context) ??
      (throw Exception(
          '$TaskListTileInheritedWidget was not found in the context'));

  static TaskListTileInheritedWidget? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant TaskListTileInheritedWidget oldWidget) =>
      true;
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.green,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Icon(
            Icons.check,
            color: context.appColors.white,
          ),
        ),
      ),
    );
  }
}

class _SecondaryBackground extends StatelessWidget {
  const _SecondaryBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.red,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Icon(
            Icons.delete,
            color: context.appColors.white,
          ),
        ),
      ),
    );
  }
}

class _MarkAsDoneCheckbox extends StatelessWidget {
  const _MarkAsDoneCheckbox();

  @override
  Widget build(BuildContext context) {
    final task = TaskListTileInheritedWidget.of(context).task;
    final isImportant = task.importance == Importance.important;
    final importanceColor = RemoteConfig.importanceColorOf(context);
    return Checkbox(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return context.appColors.green;
          }
          if (isImportant) {
            return importanceColor.withOpacity(0.16);
          }
          return Colors.transparent;
        },
      ),
      side: BorderSide(
        color:
            isImportant ? importanceColor : context.appColors.supportSeparator,
        width: 2,
      ),
      value: task.isDone,
      onChanged: (_) =>
          HomeScreen.of(context).blocDispatcher.toggleTaskAsDone(task),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    final task = TaskListTileInheritedWidget.of(context).task;
    return IconButton(
      onPressed: () => context.goNamed(AppRoute.task.name, extra: task),
      icon: Icon(
        Icons.edit,
        color: context.appColors.labelTertiary,
      ),
    );
  }
}

class _TextLine extends StatelessWidget {
  const _TextLine();

  @override
  Widget build(BuildContext context) {
    final task = TaskListTileInheritedWidget.of(context).task;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TaskText(),
          if (task.deadline != null) const _Deadline(),
        ],
      ),
    );
  }
}

class _TaskText extends StatelessWidget {
  const _TaskText();

  @override
  Widget build(BuildContext context) {
    final task = TaskListTileInheritedWidget.of(context).task;
    final importanceColor = RemoteConfig.importanceColorOf(context);
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: switch (task.importance) {
                Importance.low => Icon(
                    Icons.arrow_downward,
                    color: context.appColors.grayLight,
                    size: 20,
                  ),
                Importance.basic => const SizedBox.shrink(),
                Importance.important => Icon(
                    Icons.arrow_upward,
                    color: importanceColor,
                    size: 20,
                  ),
              },
            ),
          ),
          TextSpan(
            text: task.text,
            style: context.appTextStyles.body.copyWith(
              color: task.isDone
                  ? context.appColors.labelTertiary
                  : context.appColors.labelPrimary,
              decoration: task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: context.appColors.labelTertiary,
            ),
          ),
        ],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Deadline extends StatelessWidget {
  const _Deadline();

  @override
  Widget build(BuildContext context) {
    final task = TaskListTileInheritedWidget.of(context).task;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        context.formateDate(task.deadline!),
        style: context.appTextStyles.subhead.copyWith(
          color: context.appColors.labelTertiary,
        ),
      ),
    );
  }
}
