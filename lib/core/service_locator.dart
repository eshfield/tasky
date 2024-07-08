import 'dart:io';

import 'package:app/core/constants.dart';
import 'package:app/core/services/sync_storage.dart';
import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/core/services/network_status.dart';
import 'package:app/data/sources/remote/tasks_api.dart';
import 'package:app/core/interceptors/error_interceptor.dart';
import 'package:app/data/sources/local/tasks_storage.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/core/services/device_info_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initDependencies() async {
  final sl = GetIt.instance;

  final dio = Dio();
  const token = String.fromEnvironment(tokenArgName);
  dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  dio.options.contentType = Headers.jsonContentType;
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
  ));
  dio.interceptors.add(errorInterceptor);

  final networkStatus = NetworkStatus();
  sl.registerSingleton(networkStatus);

  final tasksApi = TasksApi(dio);

  final prefs = await SharedPreferences.getInstance();

  final tasksStorage = TasksStorage(prefs);
  final syncStorage = SyncStorage(prefs);

  final tasksRepository = TasksRepository(
    tasksApi,
    tasksStorage,
    networkStatus,
  );

  final deviceInfoService = DeviceInfoService();
  await deviceInfoService.init();
  sl.registerSingleton(deviceInfoService);

  final tasksCubit = TasksCubit();
  sl.registerSingleton(tasksCubit);

  final syncBloc = SyncBloc(tasksRepository);
  sl.registerSingleton(syncBloc);

  sl.registerSingleton(BlocDispatcher(
    tasksRepository: tasksRepository,
    tasksCubit: tasksCubit,
    syncBloc: syncBloc,
    networkStatus: networkStatus,
    syncStorage: syncStorage,
  ));
  // BlocDispatcher listens for NetworkStatus notifications,
  // so the listener must be ready before notifications start
  await networkStatus.init();
}
