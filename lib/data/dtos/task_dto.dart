import 'package:app/domain/entities/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto {
  @JsonKey(name: 'element')
  final Task task;
  @JsonKey(includeToJson: false)
  final int revision;

  TaskDto(this.task, this.revision);

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}
