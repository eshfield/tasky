import 'package:app/data/repositories/api_repository.dart';
import 'package:app/data/sources/interceptors/error_interceptor.dart';
import 'package:app/domain/models/task.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final ApiRepository apiRepository;

  SyncBloc(this.apiRepository) : super(SyncInitial()) {
    on<SyncGetTasksRequested>(
      (event, emit) async {
        emit(GetTasksInProgress());
        try {
          final tasks = await apiRepository.getTasks();
          emit(GetTasksSuccess(tasks));
        } catch (error, stackTrace) {
          _logger.w(error, stackTrace: stackTrace);
          emit(GetTasksFailure());
        }
      },
      transformer: sequential(),
    );

    on<SyncUpdateTasksRequested>(
      (event, emit) async {
        emit(SyncInProgress());
        try {
          await apiRepository.updateTasks(event.tasks);
          emit(SyncSuccess());
        } on UnsynchronizedDataException catch (error) {
          _logger.w(error);
          await apiRepository.getRevision();
          add(SyncUpdateTasksRequested(event.tasks));
        } catch (error, stackTrace) {
          _logger.w(error, stackTrace: stackTrace);
          emit(SyncFailure());
        }
      },
      transformer: sequential(),
    );

    on<SyncAddTaskRequested>(
      (event, emit) async {
        emit(SyncInProgress());
        try {
          await apiRepository.addTask(event.task);
          emit(SyncSuccess());
        } catch (error, stackTrace) {
          _logger.w(error, stackTrace: stackTrace);
          emit(SyncFailure());
        }
      },
      transformer: sequential(),
    );

    on<SyncUpdateTaskRequested>(
      (event, emit) async {
        emit(SyncInProgress());
        try {
          await apiRepository.updateTask(event.task);
          emit(SyncSuccess());
        } catch (error, stackTrace) {
          _logger.w(error, stackTrace: stackTrace);
          emit(SyncFailure());
        }
      },
      transformer: sequential(),
    );

    on<SyncRemoveTaskRequested>(
      (event, emit) async {
        emit(SyncInProgress());
        try {
          await apiRepository.removeTask(event.id);
          emit(SyncSuccess());
        } catch (error, stackTrace) {
          _logger.w(error, stackTrace: stackTrace);
          emit(SyncFailure());
        }
      },
      transformer: sequential(),
    );
  }

  final _logger = GetIt.I<Logger>();
}
