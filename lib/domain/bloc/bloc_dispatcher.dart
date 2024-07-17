import 'dart:async';

import 'package:app/core/constants.dart';
import 'package:app/core/services/network_status.dart';
import 'package:app/core/services/sync_storage.dart';
import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/domain/bloc/sync_bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:app/domain/entities/task.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class BlocDispatcher {
  final TasksRepository tasksRepository;
  final TasksCubit tasksCubit;
  final SyncBloc syncBloc;
  final NetworkStatus networkStatus;
  final SyncStorage syncStorage;
  final FirebaseAnalytics analytics;

  BlocDispatcher({
    required this.tasksRepository,
    required this.tasksCubit,
    required this.syncBloc,
    required this.networkStatus,
    required this.syncStorage,
    required this.analytics,
  }) {
    _needToSync = syncStorage.getNeedToSync();

    // autosave tasks to local storage
    _tasksSubscription = tasksCubit.stream.listen((state) {
      if (state.isInitialized) {
        tasksRepository.saveTasksLocally(state.tasks);
      }
    });

    // sync data when backed to online
    networkStatus.addListener(() {
      if (networkStatus.isOnline && _needToSync) {
        syncTasks();
      }
    });
  }

  late bool _needToSync;
  late StreamSubscription<TasksState> _tasksSubscription;

  // the method is separated in order to run it from the error screen widget
  void getInitialTasks() {
    late final StreamSubscription<SyncState> subscription;
    subscription = syncBloc.stream.listen((state) {
      if (state is GetTasksSuccess) {
        tasksCubit.setTasks(state.tasks);
        subscription.cancel();
      }
    });
    syncBloc.add(SyncGetTasksRequested());
  }

  void syncTasks() {
    syncBloc.add(SyncUpdateTasksRequested());
    _setNeedToSync(false);
  }

  void _setNeedToSync(bool value) {
    _needToSync = value;
    syncStorage.setNeedToSync(value);
  }

  void addTask(Task task) {
    tasksCubit.addTask(task);
    networkStatus.isOnline
        ? syncBloc.add(SyncAddTaskRequested(task))
        : _setNeedToSync(true);
    analytics.logEvent(
      name: AnalyticsEvent.addTask.name,
      parameters: {
        AnalyticsParameter.taskId.name: task.id,
        AnalyticsParameter.taskText.name: task.text,
      },
    );
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
    analytics.logEvent(
      name: AnalyticsEvent.toggleTaskAsDone.name,
      parameters: {
        AnalyticsParameter.taskId.name: task.id,
        AnalyticsParameter.updatedValue.name: updatedTask.isDone.toString(),
      },
    );
  }

  void removeTask(String id) {
    tasksCubit.removeTask(id);
    networkStatus.isOnline
        ? syncBloc.add(SyncRemoveTaskRequested(id))
        : _setNeedToSync(true);
    analytics.logEvent(
      name: AnalyticsEvent.removeTask.name,
      parameters: {
        AnalyticsParameter.taskId.name: id,
      },
    );
  }

  void dispose() {
    _tasksSubscription.cancel();
  }
}
