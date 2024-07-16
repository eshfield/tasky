// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskDtoImpl _$$TaskDtoImplFromJson(Map<String, dynamic> json) =>
    _$TaskDtoImpl(
      Task.fromJson(json['element'] as Map<String, dynamic>),
      (json['revision'] as num).toInt(),
    );

Map<String, dynamic> _$$TaskDtoImplToJson(_$TaskDtoImpl instance) =>
    <String, dynamic>{
      'element': instance.task,
    };
