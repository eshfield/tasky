import 'package:app/core/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

enum AppInitStatus {
  loading,
  success,
  failure,
}

class AppInitCubit extends Cubit<AppInitState> {
  AppInitCubit() : super(AppInitState(AppInitStatus.loading)) {
    _initDependencies();
  }

  Future<void> _initDependencies() async {
    try {
      await initDependencies();
      emit(AppInitState(AppInitStatus.success));
    } catch (error, stackTrace) {
      Logger().f(error, stackTrace: stackTrace);
      emit(AppInitState(AppInitStatus.failure));
    }
  }
}

final class AppInitState {
  final AppInitStatus status;

  AppInitState(this.status);
}
