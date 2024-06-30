import 'package:app/domain/models/task.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/widgets/app_top_bar.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:app/presentation/widgets/app_date_picker.dart';
import 'package:app/presentation/widgets/app_dropdown_menu.dart';
import 'package:app/presentation/widgets/app_switch.dart';
import 'package:app/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  static AddTaskScreenState of(BuildContext context) =>
      _AddTaskScreenInheritedModel.of(
        context,
        listen: false,
      ).state;

  static Priority priorityOf(BuildContext context) =>
      _AddTaskScreenInheritedModel.of(
        context,
        aspect: _Aspects.priority,
      ).priority;

  static DateTime? deadlineOf(BuildContext context) =>
      _AddTaskScreenInheritedModel.of(
        context,
        aspect: _Aspects.deadline,
      ).deadline;

  @override
  State<AddTaskScreen> createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  var priority = Priority.no;
  DateTime? deadline;

  void setPriority(Priority? priorityToSet) {
    if (priorityToSet == null) return;
    setState(() {
      priority = priorityToSet;
    });
  }

  void setDeadline(DateTime? deadlineToSet) {
    setState(() {
      deadline = deadlineToSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AddTaskScreenInheritedModel(
      state: this,
      child: Scaffold(
        backgroundColor: context.appColors.backPrimary,
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _TopBar(),
                _Content(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

enum _Aspects {
  priority,
  deadline,
}

class _AddTaskScreenInheritedModel extends InheritedModel<_Aspects> {
  final AddTaskScreenState state;
  final Priority priority;
  final DateTime? deadline;

  _AddTaskScreenInheritedModel({
    required this.state,
    required super.child,
  })  : priority = state.priority,
        deadline = state.deadline;

  static _AddTaskScreenInheritedModel of(
    BuildContext context, {
    bool listen = true,
    _Aspects? aspect,
  }) =>
      maybeOf(context, listen: listen, aspect: aspect) ??
      (throw Exception(
          '$_AddTaskScreenInheritedModel was not found in the context'));

  static _AddTaskScreenInheritedModel? maybeOf(
    BuildContext context, {
    required bool listen,
    _Aspects? aspect,
  }) =>
      listen
          ? InheritedModel.inheritFrom(context, aspect: aspect)
          : context.getInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _AddTaskScreenInheritedModel oldWidget) =>
      true;

  @override
  bool updateShouldNotifyDependent(
    covariant _AddTaskScreenInheritedModel oldWidget,
    Set<_Aspects> dependencies,
  ) =>
      (dependencies.contains(_Aspects.priority) &&
          priority != oldWidget.priority) ||
      (dependencies.contains(_Aspects.deadline) &&
          deadline != oldWidget.deadline);
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.close,
          color: context.appColors.labelPrimary,
        ),
      ),
      trailing: TextButton(
        onPressed: () {
          final formKey = AddTaskScreen.of(context).formKey;
          if (!formKey.currentState!.validate()) return;
          final task = Task(
            text: AddTaskScreen.of(context).textController.text.trim(),
            priority: AddTaskScreen.of(context).priority,
            deadline: AddTaskScreen.of(context).deadline,
          );
          Navigator.of(context).pop(task);
        },
        child: Text(
          context.l10n.save,
          style: context.appTextStyles.button.copyWith(
            color: context.appColors.blue,
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Form(
        key: AddTaskScreen.of(context).formKey,
        child: const Column(
          children: [
            _TextField(),
            SizedBox(height: 24),
            _PriorityMenu(),
            SizedBox(height: 16),
            _DeadlinePicker(),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: AddTaskScreen.of(context).textController,
      hintText: context.l10n.addTaskTextHint,
      maxLines: 4,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return context.l10n.addTaskTextError;
        }
        return null;
      },
    );
  }
}

class _PriorityMenu extends StatelessWidget {
  const _PriorityMenu();

  @override
  Widget build(BuildContext context) {
    final priority = AddTaskScreen.priorityOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(context.l10n.addTaskPriority),
        const SizedBox(height: 8),
        AppDropdownMenu(
          initialSelection: priority,
          textColor: priority == Priority.high
              ? context.appColors.red
              : context.appColors.labelPrimary,
          onSelected: AddTaskScreen.of(context).setPriority,
          dropdownMenuEntries: Priority.values.map((value) {
            final labelText = value.title(context);
            return DropdownMenuEntry(
              label: labelText,
              labelWidget: Text(
                labelText,
                style: context.appTextStyles.body.copyWith(
                  color: value == Priority.high
                      ? context.appColors.red
                      : context.appColors.labelPrimary,
                ),
              ),
              value: value,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DeadlinePicker extends StatelessWidget {
  const _DeadlinePicker();

  @override
  Widget build(BuildContext context) {
    final deadline = AddTaskScreen.deadlineOf(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Label(context.l10n.addTaskDeadline),
              if (deadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    context.formateDate(deadline),
                    style: context.appTextStyles.body.copyWith(
                      color: context.appColors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        AppSwitch(
          value: deadline != null,
          onChanged: (value) async {
            DateTime? newDeadline;
            if (value) {
              final pickedDate = await showAppDatePicker(
                context,
                initialDate: deadline,
              );
              if (pickedDate != null && pickedDate != deadline) {
                newDeadline = pickedDate;
              }
            }
            if (context.mounted) {
              AddTaskScreen.of(context).setDeadline(newDeadline);
            }
          },
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.appTextStyles.body.copyWith(
        color: context.appColors.labelPrimary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
