import 'dart:io';
import 'dart:ui';

import 'package:app/core/env_config.dart';
import 'package:app/core/interceptors/error_interceptor.dart';
import 'package:app/core/services/device_info_service.dart';
import 'package:app/core/services/network_status.dart';
import 'package:app/core/services/settings_storage.dart';
import 'package:app/core/services/sync_storage.dart';
import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/data/sources/local/tasks_storage.dart';
import 'package:app/data/sources/remote/tasks_api.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:app/firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DependencyContainer {
  BlocDispatcher get blocDispatcher;
  DeviceInfoService get deviceInfoService;
  NetworkStatus get networkStatus;
  SyncBloc get syncBloc;
  TasksCubit get tasksCubit;
  FirebaseAnalytics get analytics;
  FirebaseRemoteConfig get remoteConfig;
  bool get isInitializedSuccessfully;
}

class AppDependencyContainer implements DependencyContainer {
  @override
  late final BlocDispatcher blocDispatcher;
  @override
  late final DeviceInfoService deviceInfoService;
  @override
  late final NetworkStatus networkStatus;
  @override
  late final SyncBloc syncBloc;
  @override
  late final TasksCubit tasksCubit;
  @override
  late final FirebaseAnalytics analytics;
  @override
  late final FirebaseRemoteConfig remoteConfig;
  @override
  late final bool isInitializedSuccessfully;

  AppDependencyContainer._();

  static Future<AppDependencyContainer> create() async {
    final container = AppDependencyContainer._();
    await container._init();
    return container;
  }

  Future<void> _init() async {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      await Firebase.initializeApp(options: options);
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
        return true;
      };
      analytics = FirebaseAnalytics.instance;
      remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();

      final prefs = await SharedPreferences.getInstance();
      final tasksStorage = TasksStorage(prefs);
      final settingsStorage = SettingsStorage(prefs);
      final syncStorage = SyncStorage(prefs);

      networkStatus = NetworkStatus();

      final dio = Dio();
      final token = EnvConfig.apiToken;
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

      tasksCubit = TasksCubit(settingsStorage);
      syncBloc = SyncBloc(tasksRepository);

      blocDispatcher = BlocDispatcher(
        tasksRepository: tasksRepository,
        tasksCubit: tasksCubit,
        syncBloc: syncBloc,
        networkStatus: networkStatus,
        syncStorage: syncStorage,
        analytics: analytics,
      );
      // BlocDispatcher listens for NetworkStatus notifications,
      // so the listener must be ready before notifications start
      await networkStatus.init();

      isInitializedSuccessfully = true;
    } catch (error, stackTrace) {
      Logger().f(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      isInitializedSuccessfully = false;
    }
  }
}
