import 'package:app/domain/models/task.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/home_screen/widgets/top_bar.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:app/presentation/widgets/app_date_picker.dart';
import 'package:app/presentation/widgets/app_dropdown_menu.dart';
import 'package:app/presentation/widgets/app_switch.dart';
import 'package:app/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  var _priority = Priority.no;
  DateTime? _deadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _textField(),
                      const SizedBox(height: 24),
                      _priorityMenu(),
                      const SizedBox(height: 16),
                      _deadlinePicker(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return TopBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.close,
          color: context.appColors.labelPrimary,
        ),
      ),
      trailing: TextButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          final task = Task(
            text: _textController.text.trim(),
            priority: _priority,
            deadline: _deadline,
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

  Widget _textField() {
    return AppTextField(
      controller: _textController,
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

  Widget _priorityMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(context.l10n.addTaskPriority),
        const SizedBox(height: 8),
        AppDropdownMenu(
          initialSelection: _priority,
          textColor: _priority == Priority.high
              ? context.appColors.red
              : context.appColors.labelPrimary,
          onSelected: (value) {
            if (value == null) return;
            setState(() {
              _priority = value;
            });
          },
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

  Widget _deadlinePicker() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label(context.l10n.addTaskDeadline),
              if (_deadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    context.formateDate(_deadline!),
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
          value: _deadline != null,
          onChanged: (value) async {
            DateTime? newDeadline;
            if (value) {
              final pickedDate = await showAppDatePicker(
                context,
                initialDate: _deadline,
              );
              if (pickedDate != null && pickedDate != _deadline) {
                newDeadline = pickedDate;
              }
            }
            setState(() {
              _deadline = newDeadline;
            });
          },
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: context.appTextStyles.body.copyWith(
        color: context.appColors.labelPrimary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
