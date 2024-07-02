import 'package:app/data/dto/task_dto.dart';
import 'package:app/data/dto/tasks_dto.dart';
import 'package:app/data/sources/local_storage.dart';
import 'package:app/data/sources/api_client.dart';
import 'package:app/domain/models/task.dart';

class ApiRepository {
  final ApiClient apiClient;
  final LocalStorage localStorage;

  ApiRepository(this.apiClient, this.localStorage) {
    _revision = localStorage.loadRevision() ?? 0;
  }

  late int _revision;

  void setRevision(int value) {
    _revision = value;
    localStorage.saveRevision(value);
  }

  Future<List<Task>> getTasks() async {
    final responseTasksDto = await apiClient.getTasks();
    setRevision(responseTasksDto.revision);
    return responseTasksDto.tasks;
  }

  Future<List<Task>> updateTasks(List<Task> tasks) async {
    final responseTasksDto = await apiClient.updateTasks(
      requestTasksDto: TasksDto(tasks, _revision),
      revision: _revision,
    );
    setRevision(responseTasksDto.revision);
    return responseTasksDto.tasks;
  }

  Future<Task> addTask(Task task) async {
    final responseTaskDto = await apiClient.addTask(
      requestTaskDto: TaskDto(task, _revision),
      revision: _revision,
    );
    setRevision(responseTaskDto.revision);
    return responseTaskDto.task;
  }

  Future<Task> updateTask(Task task) async {
    final responseTaskDto = await apiClient.updateTask(
      id: task.id,
      requestTaskDto: TaskDto(task, _revision),
      revision: _revision,
    );
    setRevision(responseTaskDto.revision);
    return responseTaskDto.task;
  }

  Future<Task> removeTask(String taskId) async {
    final responseTaskDto = await apiClient.removeTask(
      id: taskId,
      revision: _revision,
    );
    setRevision(responseTaskDto.revision);
    return responseTaskDto.task;
  }
}
