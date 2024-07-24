// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TasksDtoImpl _$$TasksDtoImplFromJson(Map<String, dynamic> json) =>
    _$TasksDtoImpl(
      (json['list'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['revision'] as num).toInt(),
    );

Map<String, dynamic> _$$TasksDtoImplToJson(_$TasksDtoImpl instance) =>
    <String, dynamic>{
      'list': instance.tasks,
    };
