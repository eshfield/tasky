import 'package:app/domain/entities/task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState([]));

  void setTasks(List<Task> tasks) {
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(tasks: tasks, isInitialized: true));
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
    emit(state.copyWith(showDoneTasks: !state.showDoneTasks));
  }
}

class TasksState extends Equatable {
  final List<Task> tasks;
  final bool showDoneTasks;
  final bool isInitialized;

  const TasksState(
    this.tasks, {
    this.showDoneTasks = false,
    this.isInitialized = false,
  });

  List<Task> get tasksToDisplay =>
      showDoneTasks ? tasks : tasks.where((task) => !task.isDone).toList();

  int get doneTaskCount =>
      tasks.fold(0, (acc, task) => acc + (task.isDone ? 1 : 0));

  TasksState copyWith({
    List<Task>? tasks,
    bool? showDoneTasks,
    bool? isInitialized,
  }) {
    return TasksState(
      tasks ?? this.tasks,
      showDoneTasks: showDoneTasks ?? this.showDoneTasks,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [tasks, showDoneTasks, isInitialized];
}
