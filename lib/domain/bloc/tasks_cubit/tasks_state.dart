part of 'tasks_cubit.dart';

final class TasksState extends Equatable {
  final List<Task> tasks;
  final bool showDoneTasks;
  final bool isInitialized;

  const TasksState(
    this.tasks, {
    required this.showDoneTasks,
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
