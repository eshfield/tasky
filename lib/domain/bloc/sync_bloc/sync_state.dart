part of 'sync_bloc.dart';

sealed class SyncState {}

final class SyncInitial extends SyncState {}

final class SyncInProgress extends SyncState {}

final class SyncSuccess extends SyncState {}

final class SyncFailure extends SyncState {}

final class GetTasksInProgress extends SyncState {}

final class GetTasksSuccess extends SyncState {
  final List<Task> tasks;

  GetTasksSuccess(this.tasks);
}

final class GetTasksFailure extends SyncState {}
