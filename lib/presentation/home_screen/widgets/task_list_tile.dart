import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/models/task.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TaskListTile extends StatelessWidget {
  final Task task;

  const TaskListTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    final blocDispatcher = GetIt.I<BlocDispatcher>();
    return TaskListTileInheritedWidget(
      task: task,
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
    return ColoredBox(
      color: context.appColors.green,
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
    return ColoredBox(
      color: context.appColors.red,
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
    final blocDispatcher = GetIt.I<BlocDispatcher>();
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
      onChanged: (_) => blocDispatcher.toggleTaskAsDone(task),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    final task = TaskListTileInheritedWidget.of(context).task;
    return IconButton(
      onPressed: () => HomeScreen.of(context).openTaskScreen(task),
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
