// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TasksDto _$TasksDtoFromJson(Map<String, dynamic> json) {
  return _TasksDto.fromJson(json);
}

/// @nodoc
mixin _$TasksDto {
  @JsonKey(name: 'list')
  List<Task> get tasks => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false)
  int get revision => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TasksDtoCopyWith<TasksDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasksDtoCopyWith<$Res> {
  factory $TasksDtoCopyWith(TasksDto value, $Res Function(TasksDto) then) =
      _$TasksDtoCopyWithImpl<$Res, TasksDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'list') List<Task> tasks,
      @JsonKey(includeToJson: false) int revision});
}

/// @nodoc
class _$TasksDtoCopyWithImpl<$Res, $Val extends TasksDto>
    implements $TasksDtoCopyWith<$Res> {
  _$TasksDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? revision = null,
  }) {
    return _then(_value.copyWith(
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      revision: null == revision
          ? _value.revision
          : revision // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasksDtoImplCopyWith<$Res>
    implements $TasksDtoCopyWith<$Res> {
  factory _$$TasksDtoImplCopyWith(
          _$TasksDtoImpl value, $Res Function(_$TasksDtoImpl) then) =
      __$$TasksDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'list') List<Task> tasks,
      @JsonKey(includeToJson: false) int revision});
}

/// @nodoc
class __$$TasksDtoImplCopyWithImpl<$Res>
    extends _$TasksDtoCopyWithImpl<$Res, _$TasksDtoImpl>
    implements _$$TasksDtoImplCopyWith<$Res> {
  __$$TasksDtoImplCopyWithImpl(
      _$TasksDtoImpl _value, $Res Function(_$TasksDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? revision = null,
  }) {
    return _then(_$TasksDtoImpl(
      null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      null == revision
          ? _value.revision
          : revision // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TasksDtoImpl implements _TasksDto {
  _$TasksDtoImpl(@JsonKey(name: 'list') final List<Task> tasks,
      @JsonKey(includeToJson: false) this.revision)
      : _tasks = tasks;

  factory _$TasksDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasksDtoImplFromJson(json);

  final List<Task> _tasks;
  @override
  @JsonKey(name: 'list')
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  @JsonKey(includeToJson: false)
  final int revision;

  @override
  String toString() {
    return 'TasksDto(tasks: $tasks, revision: $revision)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasksDtoImpl &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.revision, revision) ||
                other.revision == revision));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_tasks), revision);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TasksDtoImplCopyWith<_$TasksDtoImpl> get copyWith =>
      __$$TasksDtoImplCopyWithImpl<_$TasksDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasksDtoImplToJson(
      this,
    );
  }
}

abstract class _TasksDto implements TasksDto {
  factory _TasksDto(@JsonKey(name: 'list') final List<Task> tasks,
      @JsonKey(includeToJson: false) final int revision) = _$TasksDtoImpl;

  factory _TasksDto.fromJson(Map<String, dynamic> json) =
      _$TasksDtoImpl.fromJson;

  @override
  @JsonKey(name: 'list')
  List<Task> get tasks;
  @override
  @JsonKey(includeToJson: false)
  int get revision;
  @override
  @JsonKey(ignore: true)
  _$$TasksDtoImplCopyWith<_$TasksDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
