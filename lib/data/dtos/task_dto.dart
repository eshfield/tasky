import 'package:app/domain/entities/task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart';

@freezed
class TaskDto with _$TaskDto {
  factory TaskDto(
    @JsonKey(name: 'element') Task task,
    @JsonKey(includeToJson: false) int revision,
  ) = _TaskDto;

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);
}
