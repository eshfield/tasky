import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/domain/entities/task.dart';

const deviceId = 'device1';

final now1 = DateTime.now();
final now2 = DateTime.now().subtract(const Duration(minutes: 1));
final startTasks = [
  Task(
    id: 'id1',
    text: 'One',
    createdAt: now1,
    changedAt: now1,
    lastUpdatedBy: deviceId,
  ),
  Task(
    id: 'id2',
    text: 'Two',
    createdAt: now2,
    changedAt: now2,
    lastUpdatedBy: deviceId,
  ),
];

final startState = TasksState(
  startTasks,
  showDoneTasks: false,
  isInitialized: true,
);

final taskToAdd = Task(
  id: 'id3',
  text: 'Three',
  createdAt: now1,
  changedAt: now1,
  lastUpdatedBy: deviceId,
);

final now3 = DateTime.now();
final taskToUpdate = startTasks.first.copyWith(
  text: 'Updated text',
  importance: Importance.important,
  deadline: now3,
  isDone: true,
  changedAt: now3,
  lastUpdatedBy: deviceId,
);
