import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/data/repositories/api_repository.dart';
import 'package:app/data/services/network_status.dart';
import 'package:app/data/sources/api_client.dart';
import 'package:app/data/sources/local_storage.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/utils/device_id.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<bool> initDependencies() async {
  sl.registerSingleton(Logger());

  final dio = Dio();
  const token = String.fromEnvironment(tokenArgName);
  dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  dio.options.contentType = Headers.jsonContentType;
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
  ));

  final apiClient = ApiClient(dio);

  final prefs = await SharedPreferences.getInstance();

  final localStorage = LocalStorage(prefs);
  final apiRepository = ApiRepository(apiClient, localStorage);

  final networkStatus = NetworkStatus();
  sl.registerSingleton(networkStatus);

  final deviceId = await getDeviceId();
  sl.registerSingleton(deviceId);

  final tasksCubit = TasksCubit();
  sl.registerSingleton(tasksCubit);

  final syncBloc = SyncBloc(apiRepository);
  sl.registerSingleton(syncBloc);

  sl.registerSingleton(BlocDispatcher(
    tasksCubit: tasksCubit,
    syncBloc: syncBloc,
    localStorage: localStorage,
    networkStatus: networkStatus,
  ));
  // BlocDispatcher listens for NetworkStatus notifications,
  // so the listener must be ready before notification starts
  await networkStatus.init();

  // need something to return in order to use FutureBuilder snapshot.hasData
  return true;
}
