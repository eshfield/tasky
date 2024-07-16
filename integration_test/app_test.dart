import 'package:app/core/di/dependency_container.dart';
import 'package:app/core/services/device_info_service.dart';
import 'package:app/core/services/network_status.dart';
import 'package:app/core/services/sync_storage.dart';
import 'package:app/data/dtos/task_dto.dart';
import 'package:app/data/dtos/tasks_dto.dart';
import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/data/sources/local/tasks_storage.dart';
import 'package:app/data/sources/remote/tasks_api.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

const deviceId = 'device1';
const revision = 17;
const locale = Locale('ru');
const taskToAddText = 'New task';

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockNetworkStatus extends Mock implements NetworkStatus {}

class MockAnalytics extends Mock implements FirebaseAnalytics {}

class MockRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class MockSyncStorage extends Mock implements SyncStorage {}

class MockTasksApi extends Mock implements TasksApi {}

class MockTasksStorage extends Mock implements TasksStorage {}

class FakeTaskDto extends Fake implements TaskDto {
  @override
  final int revision;

  FakeTaskDto({this.revision = 17});
}

class AppTestDependencyContainer implements DependencyContainer {
  @override
  final BlocDispatcher blocDispatcher;
  @override
  final DeviceInfoService deviceInfoService;
  @override
  final MockNetworkStatus networkStatus;
  @override
  final SyncBloc syncBloc;
  @override
  final TasksCubit tasksCubit;
  @override
  late final FirebaseAnalytics analytics;
  @override
  final MockRemoteConfig remoteConfig;
  @override
  final bool isInitializedSuccessfully;

  AppTestDependencyContainer({
    required this.blocDispatcher,
    required this.deviceInfoService,
    required this.networkStatus,
    required this.syncBloc,
    required this.tasksCubit,
    required this.analytics,
    required this.remoteConfig,
    this.isInitializedSuccessfully = true,
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockTasksApi mockTasksApi;
  late AppTestDependencyContainer dependencyContainer;
  late Task startTask;

  setUpAll(
    () {
      registerFallbackValue(FakeTaskDto());
    },
  );

  setUp(
    () async {
      // test data
      final now1 = DateTime.now();
      startTask = Task(
        id: 'id1',
        text: 'This task was here already',
        createdAt: now1,
        changedAt: now1,
        lastUpdatedBy: deviceId,
      );

      // mocked dependencies
      final mockAnalytics = MockAnalytics();
      final mockRemoteConfig = MockRemoteConfig();
      final mockNetworkStatus = MockNetworkStatus();
      final mockSyncStorage = MockSyncStorage();
      mockTasksApi = MockTasksApi();
      final mockTasksStorage = MockTasksStorage();

      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name', that: isA<String>()),
          parameters: (any(named: 'parameters', that: isA<Map>())),
        ),
      ).thenAnswer((_) async => {});
      when(() => mockRemoteConfig.getString(any(that: isA<String>())))
          .thenReturn('');
      when(() => mockRemoteConfig.onConfigUpdated)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockNetworkStatus.isOnline).thenReturn(true);
      when(() => mockTasksApi.getTasks())
          .thenAnswer((_) async => TasksDto([startTask], revision));
      when(() => mockTasksApi.addTask(
          requestTaskDto: any(
            named: 'requestTaskDto',
            that: isA<TaskDto>(),
          ),
          revision: any(
            named: 'revision',
            that: isA<int>(),
          ))).thenAnswer((_) async => FakeTaskDto());

      // real dependencies
      final tasksRepository = TasksRepository(
        mockTasksApi,
        mockTasksStorage,
        mockNetworkStatus,
      );
      final tasksCubit = TasksCubit();
      final syncBloc = SyncBloc(tasksRepository);
      final blocDispatcher = BlocDispatcher(
        tasksRepository: tasksRepository,
        tasksCubit: tasksCubit,
        syncBloc: syncBloc,
        networkStatus: mockNetworkStatus,
        syncStorage: mockSyncStorage,
        analytics: mockAnalytics,
      );
      final deviceInfoService = DeviceInfoService();
      await deviceInfoService.init();

      dependencyContainer = AppTestDependencyContainer(
        blocDispatcher: blocDispatcher,
        deviceInfoService: deviceInfoService,
        networkStatus: mockNetworkStatus,
        syncBloc: syncBloc,
        analytics: mockAnalytics,
        remoteConfig: mockRemoteConfig,
        tasksCubit: tasksCubit,
      );
    },
  );

  Finder findTaskTile(String text) {
    return find.byWidgetPredicate((widget) {
      if (widget is RichText) {
        if (widget.text is TextSpan) {
          final buffer = StringBuffer();
          (widget.text as TextSpan).computeToPlainText(buffer);
          return buffer.toString().contains(text);
        }
      }
      return false;
    });
  }

  group(
    'integration tests',
    () {
      testWidgets(
        'add task',
        (tester) async {
          await tester.pumpWidget(App(dependencyContainer));

          // wait initial tasks loading
          await tester.pumpAndSettle();
          expect(find.byKey(ValueKey(startTask.id)), findsOneWidget);

          final startTaskTile = findTaskTile(startTask.text);
          expect(startTaskTile, findsOneWidget);
          verify(() => mockTasksApi.getTasks()).called(1);

          // open add task screen
          final fab = find.byKey(const ValueKey('addTask'));
          await tester.tap(fab);
          await tester.pumpAndSettle();

          // enter new task text
          final textField = find.byKey(const ValueKey('taskTextField'));
          await tester.enterText(textField, taskToAddText);
          await tester.pumpAndSettle();

          // select importance
          final menu = find.byKey(const ValueKey('taskImportanceMenu'));
          await tester.tap(menu);
          await tester.pumpAndSettle();

          final menuItem = find.byKey(const ValueKey('important'));
          await tester.tap(menuItem);
          await tester.pumpAndSettle();

          // select deadline
          final switcher = find.byKey(const ValueKey('taskDeadline'));
          await tester.tap(switcher);
          await tester.pumpAndSettle();

          // "OK" with ru locale → "ОК" (in cyrillic)
          final lc = await GlobalMaterialLocalizations.delegate.load(locale);
          await tester.tap(find.text(lc.okButtonLabel));
          await tester.pumpAndSettle();

          // press save task button
          final saveButton = find.byKey(const ValueKey('taskSaveButton'));
          await tester.tap(saveButton);
          await tester.pumpAndSettle();

          // check new task was added
          final taskTile = findTaskTile(taskToAddText);
          expect(taskTile, findsOneWidget);
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

          await Future.delayed(const Duration(seconds: 3));
        },
      );
    },
  );
}
