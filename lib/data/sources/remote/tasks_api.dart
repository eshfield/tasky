import 'package:app/data/dtos/task_dto.dart';
import 'package:app/data/dtos/tasks_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'tasks_api.g.dart';

const revisionHeader = 'X-Last-Known-Revision';

abstract class ApiUrl {
  static const baseUrl = 'https://hive.mrdekk.ru/todo/';

  static const list = 'list';
  static const item = 'list/{id}';
}

@RestApi(baseUrl: ApiUrl.baseUrl)
abstract class TasksApi {
  factory TasksApi(Dio dio, {String baseUrl}) = _TasksApi;

  @GET(ApiUrl.list)
  Future<TasksDto> getTasks();

  @PATCH(ApiUrl.list)
  Future<TasksDto> updateTasks({
    @Body() required TasksDto requestTasksDto,
    @Header(revisionHeader) required int revision,
  });

  @POST(ApiUrl.list)
  Future<TaskDto> addTask({
    @Body() required TaskDto requestTaskDto,
    @Header(revisionHeader) required int revision,
  });

  @PUT(ApiUrl.item)
  Future<TaskDto> updateTask({
    @Path('id') required String id,
    @Body() required TaskDto requestTaskDto,
    @Header(revisionHeader) required int revision,
  });

  @DELETE(ApiUrl.item)
  Future<TaskDto> removeTask({
    @Path('id') required String id,
    @Header(revisionHeader) required int revision,
  });
}
