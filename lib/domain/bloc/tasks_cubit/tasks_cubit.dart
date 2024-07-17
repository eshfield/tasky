import 'package:app/core/services/settings_storage.dart';
import 'package:app/domain/entities/task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final SettingsStorage settingsStorage;

  TasksCubit(this.settingsStorage)
      : super(TasksState(
          const [],
          showDoneTasks: settingsStorage.getShowDoneTasks(),
        ));

  void setTasks(List<Task> tasks) {
    final sortedTasks = [...tasks]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(tasks: sortedTasks, isInitialized: true));
  }

  void addTask(Task task) {
    final tasks = [task, ...state.tasks];
    emit(state.copyWith(tasks: tasks));
  }

  void updateTask(Task task) {
    final tasks = state.tasks.map((t) {
      if (t.id != task.id) return t;
      return task;
    }).toList();
    emit(state.copyWith(tasks: tasks));
  }

  void removeTask(String id) {
    final tasks = state.tasks.where((t) => t.id != id).toList();
    emit(state.copyWith(tasks: tasks));
  }

  void toggleShowDoneTasks() {
    final newShowDoneTasks = !state.showDoneTasks;
    settingsStorage.setShowDoneTasks(newShowDoneTasks);
    emit(state.copyWith(showDoneTasks: newShowDoneTasks));
  }
}
