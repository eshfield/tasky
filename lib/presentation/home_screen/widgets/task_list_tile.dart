import 'package:app/domain/models/task.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final void Function(int) removeTask;
  final void Function(int) markTaskAsDone;

  const TaskListTile(
    this.task, {
    super.key,
    required this.removeTask,
    required this.markTaskAsDone,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        key: ValueKey(task.id),
        background: _background(context),
        secondaryBackground: _secondaryBackground(context),
        confirmDismiss: _confirmDismiss,
        onDismissed: (_) => removeTask(task.id),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _markAsDoneButton(context),
              Expanded(child: _textLine(context)),
              const SizedBox(width: 12),
              _editButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _background(BuildContext context) {
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

  Widget _secondaryBackground(BuildContext context) {
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

  Future<bool?> _confirmDismiss(direction) async {
    // no need to dismiss task with "mark as done" action
    if (direction == DismissDirection.startToEnd) {
      markTaskAsDone(task.id);
      return false;
    }
    return true;
  }

  Widget _markAsDoneButton(BuildContext context) {
    return IconButton(
      onPressed: () => markTaskAsDone(task.id),
      icon: task.isDone
          ? _doneCheckbox(context)
          : task.priority == Priority.high
              ? _blankPriorityCheckbox(context)
              : _blankCheckbox(context),
    );
  }

  Widget _editButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Logger().d('Open the task edit screen');
      },
      icon: Icon(
        Icons.edit,
        color: context.appColors.labelTertiary,
      ),
    );
  }

  Widget _doneCheckbox(BuildContext context) {
    return Icon(
      Icons.check_box,
      color: context.appColors.green,
    );
  }

  Widget _blankPriorityCheckbox(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 18,
              height: 18,
              color: context.appColors.red.withOpacity(0.16),
            ),
          ),
          Icon(
            Icons.check_box_outline_blank,
            color: context.appColors.red,
          ),
        ],
      ),
    );
  }

  Widget _blankCheckbox(BuildContext context) {
    return Icon(
      Icons.check_box_outline_blank,
      color: context.appColors.supportSeparator,
    );
  }

  Widget _textLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(context),
          if (task.deadline != null) _deadline(context),
        ],
      ),
    );
  }

  Widget _text(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: switch (task.priority) {
                Priority.no => const SizedBox.shrink(),
                Priority.low => Icon(
                    Icons.arrow_downward,
                    color: context.appColors.grayLight,
                    size: 20,
                  ),
                Priority.high => Icon(
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

  Widget _deadline(BuildContext context) {
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
