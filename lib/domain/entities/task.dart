import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/utils/unix_timestamp_json_converter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
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

@freezed
class Task with _$Task {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Task({
    required String id,
    required String text,
    @Default(Importance.basic) Importance importance,
    @UnixTimestampJsonConverter() DateTime? deadline,
    @Default(false) @JsonKey(name: 'done') bool isDone,
    @UnixTimestampJsonConverter() required DateTime createdAt,
    @UnixTimestampJsonConverter() required DateTime changedAt,
    required String lastUpdatedBy,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
