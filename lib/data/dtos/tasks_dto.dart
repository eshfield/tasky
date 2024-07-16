import 'package:app/domain/entities/task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks_dto.freezed.dart';
part 'tasks_dto.g.dart';

@freezed
class TasksDto with _$TasksDto {
  factory TasksDto(
    @JsonKey(name: 'list') List<Task> tasks,
    @JsonKey(includeToJson: false) int revision,
  ) = _TasksDto;

  factory TasksDto.fromJson(Map<String, dynamic> json) =>
      _$TasksDtoFromJson(json);
}
