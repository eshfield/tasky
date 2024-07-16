import 'package:app/core/services/network_status.dart';
import 'package:app/data/dtos/task_dto.dart';
import 'package:app/data/dtos/tasks_dto.dart';
import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/data/sources/local/tasks_storage.dart';
import 'package:app/data/sources/remote/tasks_api.dart';
import 'package:app/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTasksApi extends Mock implements TasksApi {}

class MockTasksStorage extends Mock implements TasksStorage {}

class MockNetworkStatus extends Mock implements NetworkStatus {}

class FakeTasksDto extends Fake implements TasksDto {
  @override
  final List<FakeTask> tasks;

  @override
  final int revision;

  FakeTasksDto(this.tasks, {this.revision = 17});
}

class FakeTaskDto extends Fake implements TaskDto {
  @override
  final int revision;

  FakeTaskDto({this.revision = 17});
}

class FakeTask extends Fake implements Task {
  @override
  final String id;

  FakeTask({this.id = 'id1'});
}

void main() {
  late TasksRepository tasksRepository;
  late MockTasksApi mockTasksApi;
  late MockTasksStorage mockTasksStorage;
  late MockNetworkStatus mockNetworkStatus;

  late List<List<FakeTask>?> storageResults;
  late FakeTask fakeTask;
  late List<FakeTask> tasksFromStorage;
  late List<FakeTask> tasksFromApi;

  setUpAll(() {
    fakeTask = FakeTask();
    tasksFromStorage = [FakeTask()];
    tasksFromApi = [FakeTask(), FakeTask()];

    registerFallbackValue(FakeTasksDto(tasksFromApi));
    registerFallbackValue(FakeTaskDto());
  });

  setUp(
    () {
      mockTasksApi = MockTasksApi();
      mockTasksStorage = MockTasksStorage();
      mockNetworkStatus = MockNetworkStatus();
      tasksRepository = TasksRepository(
        mockTasksApi,
        mockTasksStorage,
        mockNetworkStatus,
      );

      when(() => mockTasksStorage.getTasks())
          .thenAnswer((_) => storageResults.removeAt(0));

      when(() => mockNetworkStatus.isOnline).thenReturn(true);

      when(() => mockTasksApi.getTasks())
          .thenAnswer((_) async => FakeTasksDto(tasksFromApi));
      when(() => mockTasksApi.updateTasks(
          requestTasksDto: any(
            named: 'requestTasksDto',
            that: isA<TasksDto>(),
          ),
          revision: any(
            named: 'revision',
            that: isA<int>(),
          ))).thenAnswer((_) async => FakeTasksDto(tasksFromApi));
      when(() => mockTasksApi.addTask(
          requestTaskDto: any(
            named: 'requestTaskDto',
            that: isA<TaskDto>(),
          ),
          revision: any(
            named: 'revision',
            that: isA<int>(),
          ))).thenAnswer((_) async => FakeTaskDto());
      when(() => mockTasksApi.updateTask(
          id: any(
            named: 'id',
            that: isA<String>(),
          ),
          requestTaskDto: any(
            named: 'requestTaskDto',
            that: isA<TaskDto>(),
          ),
          revision: any(
            named: 'revision',
            that: isA<int>(),
          ))).thenAnswer((_) async => FakeTaskDto());
      when(() => mockTasksApi.removeTask(
          id: any(
            named: 'id',
            that: isA<String>(),
          ),
          revision: any(
            named: 'revision',
            that: isA<int>(),
          ))).thenAnswer((_) async => FakeTaskDto());
    },
  );

  group(
    'TasksRepository',
    () {
      test(
        'getTasks',
        () async {
          storageResults = [tasksFromStorage, null];

          // get tasks from local storage
          final actualTasksFromStorage = await tasksRepository.getTasks();
          expect(actualTasksFromStorage, tasksFromStorage);
          verifyNever(() => mockTasksApi.getTasks());

          // get tasks from API
          final actualTasksFromApi = await tasksRepository.getTasks();
          expect(actualTasksFromApi, tasksFromApi);
          verify(() => mockTasksApi.getTasks()).called(1);
        },
      );
      test(
        'updateTasks',
        () async {
          storageResults = [tasksFromStorage];
          await tasksRepository.updateTasks();
          verify(
            () => mockTasksApi.updateTasks(
                requestTasksDto: any(
                  named: 'requestTasksDto',
                  that: isA<TasksDto>(),
                ),
                revision: any(
                  named: 'revision',
                  that: isA<int>(),
                )),
          ).called(1);
        },
      );
      test(
        'addTask',
        () async {
          await tasksRepository.addTask(fakeTask);
          verify(
            () => mockTasksApi.addTask(
                requestTaskDto: any(
                  named: 'requestTaskDto',
                  that: isA<TaskDto>(),
                ),
                revision: any(
                  named: 'revision',
                  that: isA<int>(),
                )),
          ).called(1);
        },
      );
      test(
        'updateTask',
        () async {
          await tasksRepository.updateTask(fakeTask);
          verify(
            () => mockTasksApi.updateTask(
                id: any(
                  named: 'id',
                  that: isA<String>(),
                ),
                requestTaskDto: any(
                  named: 'requestTaskDto',
                  that: isA<TaskDto>(),
                ),
                revision: any(
                  named: 'revision',
                  that: isA<int>(),
                )),
          ).called(1);
        },
      );
      test(
        'removeTask',
        () async {
          await tasksRepository.removeTask(fakeTask.id);
          verify(
            () => mockTasksApi.removeTask(
                id: any(
                  named: 'id',
                  that: isA<String>(),
                ),
                revision: any(
                  named: 'revision',
                  that: isA<int>(),
                )),
          ).called(1);
        },
      );
    },
  );
}
