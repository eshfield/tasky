import 'dart:async';

import 'package:app/data/services/network_status.dart';
import 'package:app/data/sources/local_storage.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/domain/models/task.dart';
import 'package:logger/logger.dart';

class BlocDispatcher {
  final TasksCubit tasksCubit;
  final SyncBloc syncBloc;
  final LocalStorage localStorage;
  final NetworkStatus networkStatus;

  BlocDispatcher({
    required this.tasksCubit,
    required this.syncBloc,
    required this.localStorage,
    required this.networkStatus,
  }) {
    // save tasks to local storage
    tasksCubit.stream.listen((state) {
      if (state.isInitialized) {
        localStorage.saveTasks(state.tasks);
      }
    });
    // sync data when backed to online
    networkStatus.addListener(() {
      if (networkStatus.isOnline && _needToSync) {
        final storedTasks = localStorage.loadTasks();
        if (storedTasks == null) {
          Logger().w('storedTasks is null');
          return;
        }
        final storedRevision = localStorage.loadRevision() ?? 0;
        syncBloc.add(SyncUpdateTasksRequested(storedTasks, storedRevision));
      }
    });
  }

  var _needToSync = false;

  void _markAsNeedToSync() => _needToSync = true;

  void init() {
    final storedTasks = localStorage.loadTasks();
    if (storedTasks != null) {
      tasksCubit.setTasks(storedTasks);
      return;
    }
    // no local saved tasks → rolling up backup from server
    late final StreamSubscription<SyncState> subscription;
    subscription = syncBloc.stream.listen((state) {
      if (state is GetTasksSuccess) {
        tasksCubit.setTasks(state.tasks);
        subscription.cancel();
      }
    });
    syncBloc.add(SyncGetTasksRequested());
  }

  void addTask(Task task) {
    tasksCubit.addTask(task);
    networkStatus.isOnline
        ? syncBloc.add(SyncAddTaskRequested(task))
        : _markAsNeedToSync();
  }

  void updateTask(Task task) {
    tasksCubit.updateTask(task);
    networkStatus.isOnline
        ? syncBloc.add(SyncUpdateTaskRequested(task))
        : _markAsNeedToSync();
  }

  void toggleTaskAsDone(Task task) {
    final updatedTask = task.copyWith(
      isDone: !task.isDone,
      changedAt: DateTime.now(),
    );
    updateTask(updatedTask);
  }

  void removeTask(String id) {
    tasksCubit.removeTask(id);
    networkStatus.isOnline
        ? syncBloc.add(SyncRemoveTaskRequested(id))
        : _markAsNeedToSync();
  }
}
