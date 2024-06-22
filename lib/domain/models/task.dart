import 'package:app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

enum Priority {
  no,
  low,
  high;

  String title(BuildContext context) {
    return switch (this) {
      no => context.l10n.addTaskPriorityNo,
      low => context.l10n.addTaskPriorityLow,
      high => context.l10n.addTaskPriorityHigh,
    };
  }
}

class Task {
  final int id;
  final String text;
  final Priority priority;
  final DateTime? deadline;
  final bool isDone;

  Task({
    id,
    required this.text,
    required this.priority,
    required this.deadline,
    this.isDone = false,
  }) : id = id ?? UniqueKey().hashCode;

  Task copyWith({
    String? text,
    Priority? priority,
    DateTime? deadline,
    bool? isDone,
  }) {
    return Task(
      id: id,
      text: text ?? this.text,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
    );
  }
}
