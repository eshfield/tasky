import 'package:app/domain/entities/task.dart';
import 'package:app/core/extensions/l10n_extension.dart';
import 'package:app/core/extensions/app_theme_extension.dart';
import 'package:app/core/routing.dart';
import 'package:app/presentation/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final bool isFirst;
  final bool isLast;

  const TaskListTile(
    this.task, {
    super.key,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final blocDispatcher = HomeScreen.of(context).blocDispatcher;
    return TaskListTileInheritedWidget(
      task: task,
      isFirst: isFirst,
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: Dismissible(
          key: ValueKey(task.id),
          background: const _Background(),
          secondaryBackground: const _SecondaryBackground(),
          confirmDismiss: (direction) async {
            // no need to dismiss task with "mark as done" action
            if (direction == DismissDirection.startToEnd) {
              blocDispatcher.toggleTaskAsDone(task);
              return false;
            }
            return true;
          },
          onDismissed: (_) => blocDispatcher.removeTask(task.id),
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: isFirst ? 8 : 0,
              bottom: isLast ? 8 : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MarkAsDoneCheckbox(),
                Expanded(child: _TextLine()),
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
  final bool isFirst;

  const TaskListTileInheritedWidget({
    super.key,
    required this.task,
    required this.isFirst,
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
    final isFirst = TaskListTileInheritedWidget.of(context).isFirst;
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.green,
        borderRadius: isFirst
            ? const BorderRadius.only(topLeft: Radius.circular(12))
            : BorderRadius.zero,
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
    final isFirst = TaskListTileInheritedWidget.of(context).isFirst;
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.red,
        borderRadius: isFirst
            ? const BorderRadius.only(topRight: Radius.circular(12))
            : BorderRadius.zero,
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
    return Checkbox(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return context.appColors.green;
          }
          if (isImportant) {
            return context.appColors.red.withOpacity(0.16);
          }
          return Colors.transparent;
        },
      ),
      side: BorderSide(
        color: isImportant
            ? context.appColors.red
            : context.appColors.supportSeparator,
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
                    color: context.appColors.red,
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