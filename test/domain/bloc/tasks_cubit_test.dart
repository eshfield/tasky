import 'package:app/core/services/settings_storage.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_data.dart';

class MockSettingsStorage extends Mock implements SettingsStorage {}

void main() {
  late MockSettingsStorage mockSettingsStorage;

  setUp(
    () {
      mockSettingsStorage = MockSettingsStorage();
      when(() => mockSettingsStorage.getShowDoneTasks()).thenReturn(false);
    },
  );

  TasksCubit build() => TasksCubit(mockSettingsStorage);

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
