import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/utils/unix_timestamp_json_converter.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

enum Importance {
  low,
  basic,
  important;

  String title(BuildContext context) {
    return switch (this) {
      low => context.l10n.taskImportanceLow,
      basic => context.l10n.taskImportanceBasic,
      important => context.l10n.taskImportanceImportant,
    };
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Task {
  final String id;
  final String text;
  final Importance importance;
  @UnixTimestampJsonConverter()
  final DateTime? deadline;
  @JsonKey(name: 'done')
  final bool isDone;
  @UnixTimestampJsonConverter()
  final DateTime createdAt;
  @UnixTimestampJsonConverter()
  final DateTime changedAt;
  @JsonKey()
  final String lastUpdatedBy;

  Task({
    required this.id,
    required this.text,
    this.importance = Importance.basic,
    this.deadline,
    this.isDone = false,
    required this.createdAt,
    required this.changedAt,
    required this.lastUpdatedBy,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    String? text,
    Importance? importance,
    DateTime? Function()? deadline,
    bool? isDone,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Task(
      id: id,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline != null ? deadline() : this.deadline,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      changedAt: changedAt ?? this.changedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }
}
