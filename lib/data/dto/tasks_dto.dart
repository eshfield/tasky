import 'package:app/domain/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasks_dto.g.dart';

@JsonSerializable()
class TasksDto {
  @JsonKey(name: 'list')
  final List<Task> tasks;
  @JsonKey(includeToJson: false)
  final int revision;

  TasksDto(this.tasks, this.revision);

  factory TasksDto.fromJson(Map<String, dynamic> json) =>
      _$TasksDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TasksDtoToJson(this);
}
