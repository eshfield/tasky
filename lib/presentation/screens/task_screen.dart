import 'package:app/core/di/dependency_container.dart';
import 'package:app/core/services/device_info_service.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/core/extensions/l10n_extension.dart';
import 'package:app/presentation/widgets/app_top_bar.dart';
import 'package:app/core/extensions/app_theme_extension.dart';
import 'package:app/presentation/widgets/app_date_picker.dart';
import 'package:app/presentation/widgets/app_dropdown_menu.dart';
import 'package:app/presentation/widgets/app_switch.dart';
import 'package:app/presentation/widgets/app_text_field.dart';
import 'package:app/core/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;

  const TaskScreen(this.task, {super.key});

  static TaskScreenState of(BuildContext context) =>
      _TaskScreenInheritedModel.of(
        context,
        listen: false,
      ).state;

  static Importance importanceOf(BuildContext context) =>
      _TaskScreenInheritedModel.of(
        context,
        aspect: _Aspect.importance,
      ).importance;

  static DateTime? deadlineOf(BuildContext context) =>
      _TaskScreenInheritedModel.of(
        context,
        aspect: _Aspect.deadline,
      ).deadline;

  @override
  State<TaskScreen> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  late final DependencyContainer dependencyContainer;
  late final BlocDispatcher blocDispatcher;
  late final DeviceInfoService deviceInfoService;

  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  var importance = Importance.basic;
  DateTime? deadline;
  late final bool isEditing;

  @override
  void initState() {
    super.initState();
    dependencyContainer = context.read<DependencyContainer>();
    blocDispatcher = dependencyContainer.blocDispatcher;
    deviceInfoService = dependencyContainer.deviceInfoService;

    final task = widget.task;
    isEditing = task != null;
    if (isEditing) {
      textController.text = task!.text;
      importance = task.importance;
      deadline = task.deadline;
    }
  }

  void setImportance(Importance? importanceToSet) {
    if (importanceToSet == null) return;
    setState(() {
      importance = importanceToSet;
    });
  }

  void setDeadline(DateTime? deadlineToSet) {
    setState(() {
      deadline = deadlineToSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _TaskScreenInheritedModel(
      state: this,
      child: Scaffold(
        backgroundColor: context.appColors.backPrimary,
        body: const SafeArea(
          child: Column(
            children: [
              _TopBar(),
              Expanded(child: _Content()),
            ],
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

enum _Aspect {
  importance,
  deadline,
}

class _TaskScreenInheritedModel extends InheritedModel<_Aspect> {
  final TaskScreenState state;
  final Importance importance;
  final DateTime? deadline;

  _TaskScreenInheritedModel({
    required this.state,
    required super.child,
  })  : importance = state.importance,
        deadline = state.deadline;

  static _TaskScreenInheritedModel of(
    BuildContext context, {
    bool listen = true,
    _Aspect? aspect,
  }) =>
      maybeOf(context, listen: listen, aspect: aspect) ??
      (throw Exception(
          '$_TaskScreenInheritedModel was not found in the context'));

  static _TaskScreenInheritedModel? maybeOf(
    BuildContext context, {
    required bool listen,
    _Aspect? aspect,
  }) =>
      listen
          ? InheritedModel.inheritFrom(context, aspect: aspect)
          : context.getInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _TaskScreenInheritedModel oldWidget) =>
      true;

  @override
  bool updateShouldNotifyDependent(
    covariant _TaskScreenInheritedModel oldWidget,
    Set<_Aspect> dependencies,
  ) =>
      (dependencies.contains(_Aspect.importance) &&
          importance != oldWidget.importance) ||
      (dependencies.contains(_Aspect.deadline) &&
          deadline != oldWidget.deadline);
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      leading: IconButton(
        onPressed: () => context.goNamed(AppRoute.home.name),
        icon: Icon(
          Icons.close,
          color: context.appColors.labelPrimary,
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
        key: TaskScreen.of(context).formKey,
        child: Column(
          children: [
            const _TextField(),
            const SizedBox(height: 24),
            const _ImportanceMenu(),
            const SizedBox(height: 16),
            const _DeadlinePicker(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (TaskScreen.of(context).isEditing)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: _RemoveButton(),
                  ),
                const _SaveButton(),
              ],
            )
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
      autofocus: !TaskScreen.of(context).isEditing,
      controller: TaskScreen.of(context).textController,
      hintText: context.l10n.taskTextHint,
      minLines: 4,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return context.l10n.taskTextError;
        }
        return null;
      },
    );
  }
}

class _ImportanceMenu extends StatelessWidget {
  const _ImportanceMenu();

  @override
  Widget build(BuildContext context) {
    final importance = TaskScreen.importanceOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(context.l10n.taskImportance),
        const SizedBox(height: 8),
        AppDropdownMenu(
          initialSelection: importance,
          textColor: importance == Importance.important
              ? context.appColors.red
              : context.appColors.labelPrimary,
          onSelected: TaskScreen.of(context).setImportance,
          dropdownMenuEntries: Importance.values.map((value) {
            final labelText = value.title(context);
            return DropdownMenuEntry(
              label: labelText,
              labelWidget: Text(
                labelText,
                style: context.appTextStyles.body.copyWith(
                  color: value == Importance.important
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
    final deadline = TaskScreen.deadlineOf(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Label(context.l10n.taskDeadline),
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
              TaskScreen.of(context).setDeadline(newDeadline);
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

class _RemoveButton extends StatelessWidget {
  const _RemoveButton();

  @override
  Widget build(BuildContext context) {
    final task = TaskScreen.of(context).widget.task;
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: context.appColors.red,
      ),
      onPressed: () {
        TaskScreen.of(context).blocDispatcher.removeTask(task!.id);
        context.goNamed(AppRoute.home.name);
      },
      child: Text(
        context.l10n.remove,
        style: context.appTextStyles.body.copyWith(
          color: context.appColors.white,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: context.appColors.blue,
      ),
      onPressed: () {
        final formKey = TaskScreen.of(context).formKey;
        if (!formKey.currentState!.validate()) return;
        final text = TaskScreen.of(context).textController.text.trim();
        final importance = TaskScreen.of(context).importance;
        final now = DateTime.now();
        final deviceId = TaskScreen.of(context).deviceInfoService.deviceId;
        if (TaskScreen.of(context).isEditing) {
          final taskToEdit = TaskScreen.of(context).widget.task;
          final editedTask = taskToEdit!.copyWith(
            text: text,
            importance: importance,
            deadline: () => TaskScreen.of(context).deadline,
            changedAt: now,
            lastUpdatedBy: deviceId,
          );
          TaskScreen.of(context).blocDispatcher.updateTask(editedTask);
        } else {
          final taskToAdd = Task(
            id: const Uuid().v4(),
            text: text,
            importance: importance,
            deadline: TaskScreen.of(context).deadline,
            createdAt: now,
            changedAt: now,
            lastUpdatedBy: deviceId,
          );
          TaskScreen.of(context).blocDispatcher.addTask(taskToAdd);
        }
        context.goNamed(AppRoute.home.name);
      },
      child: Text(
        context.l10n.save,
        style: context.appTextStyles.body.copyWith(
          color: context.appColors.white,
        ),
      ),
    );
  }
}
