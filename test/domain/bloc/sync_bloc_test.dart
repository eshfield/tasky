import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/domain/bloc/sync_bloc/sync_bloc.dart';
import 'package:app/domain/entities/task.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTasksRepository extends Mock implements TasksRepository {}

class FakeTask extends Fake implements Task {}

void main() {
  late MockTasksRepository mockTasksRepository;

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(
    () {
      mockTasksRepository = MockTasksRepository();
      when(() => mockTasksRepository.getTasks())
          .thenAnswer((_) async => [FakeTask()]);
      when(() => mockTasksRepository.updateTasks()).thenAnswer((_) async {});
      when(() => mockTasksRepository.addTask(any(that: isA<Task>())))
          .thenAnswer((_) async {});
      when(() => mockTasksRepository.updateTask(any(that: isA<Task>())))
          .thenAnswer((_) async {});
      when(() => mockTasksRepository.removeTask(any(that: isA<String>())))
          .thenAnswer((_) async {});
    },
  );

  SyncBloc build() => SyncBloc(mockTasksRepository);

  group(
    'SyncBloc',
    () {
      blocTest(
        'SyncGetTasksRequested',
        build: build,
        act: (bloc) => bloc.add(SyncGetTasksRequested()),
        expect: () => [
          isA<GetTasksInProgress>(),
          const TypeMatcher<GetTasksSuccess>()
              .having((st) => st.tasks, 'state tasks', isA<List<Task>>()),
        ],
        verify: (_) {
          verify(() => mockTasksRepository.getTasks()).called(1);
        },
      );
      blocTest(
        'SyncUpdateTasksRequested',
        build: build,
        act: (bloc) => bloc.add(SyncUpdateTasksRequested()),
        expect: () => [
          isA<SyncInProgress>(),
          isA<SyncSuccess>(),
        ],
        verify: (_) {
          verify(() => mockTasksRepository.updateTasks()).called(1);
        },
      );
      blocTest(
        'SyncAddTaskRequested',
        build: build,
        act: (bloc) => bloc.add(SyncAddTaskRequested(FakeTask())),
        expect: () => [
          isA<SyncInProgress>(),
          isA<SyncSuccess>(),
        ],
        verify: (_) {
          verify(() => mockTasksRepository.addTask(any(that: isA<Task>())))
              .called(1);
        },
      );
      blocTest(
        'SyncUpdateTaskRequested',
        build: build,
        act: (bloc) => bloc.add(SyncUpdateTaskRequested(FakeTask())),
        expect: () => [
          isA<SyncInProgress>(),
          isA<SyncSuccess>(),
        ],
        verify: (_) {
          verify(() => mockTasksRepository.updateTask(any(that: isA<Task>())))
              .called(1);
        },
      );
      blocTest(
        'SyncRemoveTaskRequested',
        build: build,
        act: (bloc) => bloc.add(SyncRemoveTaskRequested('id1')),
        expect: () => [
          isA<SyncInProgress>(),
          isA<SyncSuccess>(),
        ],
        verify: (_) {
          verify(() => mockTasksRepository.removeTask(any(that: isA<String>())))
              .called(1);
        },
      );
    },
  );
}
