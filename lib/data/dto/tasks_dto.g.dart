// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksDto _$TasksDtoFromJson(Map<String, dynamic> json) => TasksDto(
      (json['list'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['revision'] as num).toInt(),
    );

Map<String, dynamic> _$TasksDtoToJson(TasksDto instance) => <String, dynamic>{
      'list': instance.tasks,
    };
