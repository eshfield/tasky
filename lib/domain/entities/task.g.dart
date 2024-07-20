// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      text: json['text'] as String,
      importance:
          $enumDecodeNullable(_$ImportanceEnumMap, json['importance']) ??
              Importance.basic,
      deadline: _$JsonConverterFromJson<int, DateTime>(
          json['deadline'], const UnixTimestampJsonConverter().fromJson),
      isDone: json['done'] as bool? ?? false,
      createdAt: const UnixTimestampJsonConverter()
          .fromJson((json['created_at'] as num).toInt()),
      changedAt: const UnixTimestampJsonConverter()
          .fromJson((json['changed_at'] as num).toInt()),
      lastUpdatedBy: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': _$ImportanceEnumMap[instance.importance]!,
      'deadline': _$JsonConverterToJson<int, DateTime>(
          instance.deadline, const UnixTimestampJsonConverter().toJson),
      'done': instance.isDone,
      'created_at':
          const UnixTimestampJsonConverter().toJson(instance.createdAt),
      'changed_at':
          const UnixTimestampJsonConverter().toJson(instance.changedAt),
      'last_updated_by': instance.lastUpdatedBy,
    };

const _$ImportanceEnumMap = {
  Importance.low: 'low',
  Importance.basic: 'basic',
  Importance.important: 'important',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
