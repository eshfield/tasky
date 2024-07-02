import 'package:app/data/repositories/api_repository.dart';
import 'package:app/domain/models/task.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

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
          apiRepository.setRevision(event.revision);
          await apiRepository.updateTasks(event.tasks);
          emit(SyncSuccess());
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

// STATE
sealed class SyncState {}

final class SyncInitial extends SyncState {}

final class SyncInProgress extends SyncState {}

final class SyncSuccess extends SyncState {}

final class SyncFailure extends SyncState {}

final class GetTasksInProgress extends SyncState {}

final class GetTasksSuccess extends SyncState {
  final List<Task> tasks;

  GetTasksSuccess(this.tasks);
}

final class GetTasksFailure extends SyncState {}

// EVENT
sealed class SyncEvent {}

final class SyncGetTasksRequested extends SyncEvent {}

final class SyncUpdateTasksRequested extends SyncEvent {
  final List<Task> tasks;
  final int revision;

  SyncUpdateTasksRequested(this.tasks, this.revision);
}

final class SyncAddTaskRequested extends SyncEvent {
  final Task task;

  SyncAddTaskRequested(this.task);
}

final class SyncUpdateTaskRequested extends SyncEvent {
  final Task task;

  SyncUpdateTaskRequested(this.task);
}

final class SyncRemoveTaskRequested extends SyncEvent {
  final String id;

  SyncRemoveTaskRequested(this.id);
}
