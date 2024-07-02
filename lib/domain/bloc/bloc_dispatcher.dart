import 'dart:async';

import 'package:app/data/services/network_status.dart';
import 'package:app/data/sources/local_storage.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/domain/models/task.dart';
import 'package:get_it/get_it.dart';
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
    _needToSync = localStorage.loadNeedToSync() ?? false;

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
          _logger.w('storedTasks is null');
          return;
        }
        final storedRevision = localStorage.loadRevision() ?? 0;
        syncBloc.add(SyncUpdateTasksRequested(storedTasks, storedRevision));
        _setNeedToSync(false);
      }
    });
    init();
  }

  late bool _needToSync;

  final _logger = GetIt.I<Logger>();

  void _setNeedToSync(bool value) {
    _needToSync = value;
    localStorage.saveNeedToSync(value);
  }

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
        : _setNeedToSync(true);
  }

  void updateTask(Task task) {
    tasksCubit.updateTask(task);
    networkStatus.isOnline
        ? syncBloc.add(SyncUpdateTaskRequested(task))
        : _setNeedToSync(true);
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
        : _setNeedToSync(true);
  }
}
