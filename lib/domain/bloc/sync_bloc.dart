import 'package:app/data/repositories/tasks_repository.dart';
import 'package:app/core/interceptors/error_interceptor.dart';
import 'package:app/domain/entities/task.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final TasksRepository tasksRepository;

  SyncBloc(this.tasksRepository) : super(SyncInitial()) {
    on<SyncGetTasksRequested>(
      (event, emit) async {
        emit(GetTasksInProgress());
        try {
          final tasks = await tasksRepository.getTasks();
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
          await tasksRepository.updateTasks();
          emit(SyncSuccess());
        } on UnsynchronizedDataException catch (error) {
          _logger.w(error);
          await tasksRepository.getRevision();
          add(SyncUpdateTasksRequested());
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
          await tasksRepository.addTask(event.task);
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
          await tasksRepository.updateTask(event.task);
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
          await tasksRepository.removeTask(event.id);
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
