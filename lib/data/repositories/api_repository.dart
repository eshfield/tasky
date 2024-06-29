import 'dart:io';

import 'package:app/data/dto/task_dto.dart';
import 'package:app/data/dto/tasks_dto.dart';
import 'package:app/data/sources/local_storage.dart';
import 'package:app/data/sources/api_client.dart';
import 'package:app/domain/models/task.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const tokenArgName = 'TOKEN';

class ApiRepository {
  late final ApiClient apiClient;
  final LocalStorage localStorage;

  late int _revision;

  ApiRepository(this.localStorage) {
    final dio = Dio();
    const token = String.fromEnvironment(tokenArgName);
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    dio.options.contentType = Headers.jsonContentType;
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
    apiClient = ApiClient(dio);
    _revision = localStorage.loadRevision() ?? 0;
  }

  void updateRevision(int revision) {
    _revision = revision;
    localStorage.saveRevision(revision);
  }

  Future<List<Task>> getTasks() async {
    final responseTasksDto = await apiClient.getTasks();
    updateRevision(responseTasksDto.revision);
    return responseTasksDto.tasks;
  }

  Future<List<Task>> updateTasks(List<Task> tasks) async {
    final responseTasksDto = await apiClient.updateTasks(
      requestTasksDto: TasksDto(tasks, _revision),
      revision: _revision,
    );
    updateRevision(responseTasksDto.revision);
    return responseTasksDto.tasks;
  }

  Future<Task> addTask(Task task) async {
    final responseTaskDto = await apiClient.addTask(
      requestTaskDto: TaskDto(task, _revision),
      revision: _revision,
    );
    updateRevision(responseTaskDto.revision);
    return responseTaskDto.task;
  }

  Future<Task> updateTask(Task task) async {
    final responseTaskDto = await apiClient.updateTask(
      id: task.id,
      requestTaskDto: TaskDto(task, _revision),
      revision: _revision,
    );
    updateRevision(responseTaskDto.revision);
    return responseTaskDto.task;
  }

  Future<Task> removeTask(String taskId) async {
    final responseTaskDto = await apiClient.removeTask(
      id: taskId,
      revision: _revision,
    );
    updateRevision(responseTaskDto.revision);
    return responseTaskDto.task;
  }
}
