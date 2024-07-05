part of 'sync_bloc.dart';

sealed class SyncEvent {}

final class SyncGetTasksRequested extends SyncEvent {}

final class SyncUpdateTasksRequested extends SyncEvent {
  final List<Task> tasks;

  SyncUpdateTasksRequested(this.tasks);
}

final class SyncAddTaskRequested extends SyncEvent {
  final Task task;

  SyncAddTaskRequested(this.task);
}

final class SyncUpdateTaskRequested extends SyncEvent {
  final Task task;

  SyncUpdateTaskRequested(this.task);
}

final class SyncRemoveTaskRequested extends SyncEvent {
  final String id;

  SyncRemoveTaskRequested(this.id);
}
