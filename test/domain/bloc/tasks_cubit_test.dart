import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/domain/entities/task.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

const deviceId = 'device1';

void main() {
  late List<Task> startTasks;
  late TasksState startState;
  late Task taskToAdd;
  late Task taskToUpdate;

  setUp(
    () {
      final now1 = DateTime.now();
      final now2 = DateTime.now().subtract(const Duration(minutes: 1));
      startTasks = [
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

      startState = TasksState(startTasks, isInitialized: true);

      taskToAdd = Task(
        id: 'id3',
        text: 'Three',
        createdAt: now1,
        changedAt: now1,
        lastUpdatedBy: deviceId,
      );

      final now3 = DateTime.now();
      taskToUpdate = startTasks.first.copyWith(
        text: 'Updated text',
        importance: Importance.important,
        deadline: () => now3,
        isDone: true,
        changedAt: now3,
        lastUpdatedBy: deviceId,
      );
    },
  );

  TasksCubit build() => TasksCubit();

  group(
    'TasksCubit',
    () {
      blocTest(
        'setTasks',
        build: build,
        act: (cubit) => cubit.setTasks(startTasks),
        expect: () => [startState],
      );
      blocTest(
        'addTask',
        build: build,
        seed: () => startState,
        act: (cubit) => cubit.addTask(taskToAdd),
        expect: () => [
          const TypeMatcher<TasksState>()
              .having((st) => st.tasks, 'tasks length', hasLength(3))
              .having((st) => st.tasks.first, 'first task', taskToAdd)
              .having((st) => st.tasks.sublist(1), 'other tasks', startTasks),
        ],
      );
      blocTest(
        'updateTask',
        build: build,
        seed: () => startState,
        act: (cubit) => cubit.updateTask(taskToUpdate),
        expect: () => [
          const TypeMatcher<TasksState>()
              .having((st) => st.tasks.first, 'updated task', taskToUpdate),
        ],
      );
      blocTest(
        'removeTask',
        build: build,
        seed: () => startState,
        act: (cubit) => cubit.removeTask(startTasks.first.id),
        expect: () => [
          const TypeMatcher<TasksState>()
              .having((st) => st.tasks, 'tasks length', hasLength(1))
              .having(
                (st) => st.tasks.first,
                'left task is not what we have removed',
                isNot(equals(startTasks.first.id)),
              )
        ],
      );
      blocTest(
        'toggleShowDoneTasks',
        build: build,
        seed: () => startState,
        act: (cubit) {
          cubit.toggleShowDoneTasks();
          cubit.toggleShowDoneTasks();
        },
        expect: () => [
          const TypeMatcher<TasksState>()
              .having((st) => st.showDoneTasks, 'goes to true', isTrue),
          const TypeMatcher<TasksState>()
              .having((st) => st.showDoneTasks, 'back to false', isFalse),
        ],
      );
    },
  );
}
