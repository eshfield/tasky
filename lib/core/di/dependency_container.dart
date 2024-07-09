import 'dart:io';

import 'package:app/core/constants.dart';
import 'package:app/core/interceptors/error_interceptor.dart';
import 'package:app/core/services/device_info_service.dart';
import 'package:app/core/services/network_status.dart';
import 'package:app/core/services/sync_storage.dart';
import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/data/sources/local/tasks_storage.dart';
import 'package:app/data/sources/remote/tasks_api.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyContainer {
  late final BlocDispatcher blocDispatcher;
  late final DeviceInfoService deviceInfoService;
  late final NetworkStatus networkStatus;
  late final SyncBloc syncBloc;
  late final TasksCubit tasksCubit;
  late final bool isInitializedSuccessfully;

  DependencyContainer._();

  static Future<DependencyContainer> create() async {
    final container = DependencyContainer._();
    await container._init();
    return container;
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksStorage = TasksStorage(prefs);
      final syncStorage = SyncStorage(prefs);

      networkStatus = NetworkStatus();

      final dio = Dio();
      const token = String.fromEnvironment(tokenArgName);
      dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      dio.options.contentType = Headers.jsonContentType;
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ));
      dio.interceptors.add(errorInterceptor);

      final tasksApi = TasksApi(dio);

      final tasksRepository = TasksRepository(
        tasksApi,
        tasksStorage,
        networkStatus,
      );

      deviceInfoService = DeviceInfoService();
      await deviceInfoService.init();

      tasksCubit = TasksCubit();
      syncBloc = SyncBloc(tasksRepository);

      blocDispatcher = BlocDispatcher(
        tasksRepository: tasksRepository,
        tasksCubit: tasksCubit,
        syncBloc: syncBloc,
        networkStatus: networkStatus,
        syncStorage: syncStorage,
      );
      // BlocDispatcher listens for NetworkStatus notifications,
      // so the listener must be ready before notifications start
      await networkStatus.init();

      isInitializedSuccessfully = true;
    } catch (error, stackTrace) {
      Logger().f(error, stackTrace: stackTrace);
      isInitializedSuccessfully = false;
    }
  }
}
