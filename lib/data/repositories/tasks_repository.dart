import 'package:app/core/services/network_status.dart';
import 'package:app/data/dtos/task_dto.dart';
import 'package:app/data/dtos/tasks_dto.dart';
import 'package:app/data/sources/local/tasks_storage.dart';
import 'package:app/data/sources/remote/tasks_api.dart';
import 'package:app/domain/entities/task.dart';

class TasksRepository {
  final TasksApi tasksApi;
  final TasksStorage tasksStorage;
  final NetworkStatus networkStatus;

  TasksRepository(
    this.tasksApi,
    this.tasksStorage,
    this.networkStatus,
  ) {
    _revision = tasksStorage.getRevision();
  }

  late int _revision;

  void setRevision(int value) {
    _revision = value;
    tasksStorage.setRevision(value);
  }

  Future<void> getRevision() async {
    final responseTasksDto = await tasksApi.getTasks();
    setRevision(responseTasksDto.revision);
  }

  Future<List<Task>> getTasks() async {
    final storedTasks = tasksStorage.getTasks();
    if (storedTasks.isEmpty && networkStatus.isOnline) {
      final responseTasksDto = await tasksApi.getTasks();
      setRevision(responseTasksDto.revision);
      return responseTasksDto.tasks;
    }
    return storedTasks;
  }

  Future<void> updateTasks() async {
    final storedTasks = tasksStorage.getTasks();
    final responseTasksDto = await tasksApi.updateTasks(
      requestTasksDto: TasksDto(storedTasks, _revision),
      revision: _revision,
    );
    setRevision(responseTasksDto.revision);
  }

  void saveTasksLocally(List<Task> tasks) => tasksStorage.setTasks(tasks);

  Future<void> addTask(Task task) async {
    final responseTaskDto = await tasksApi.addTask(
      requestTaskDto: TaskDto(task, _revision),
      revision: _revision,
    );
    setRevision(responseTaskDto.revision);
  }

  Future<void> updateTask(Task task) async {
    final responseTaskDto = await tasksApi.updateTask(
      id: task.id,
      requestTaskDto: TaskDto(task, _revision),
      revision: _revision,
    );
    setRevision(responseTaskDto.revision);
  }

  Future<void> removeTask(String taskId) async {
    final responseTaskDto = await tasksApi.removeTask(
      id: taskId,
      revision: _revision,
    );
    setRevision(responseTaskDto.revision);
  }
}
