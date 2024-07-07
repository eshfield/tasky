import 'package:app/data/dto/task_dto.dart';
import 'package:app/data/dto/tasks_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

const revisionHeader = 'X-Last-Known-Revision';

abstract class ApiUrl {
  static const baseUrl = 'https://hive.mrdekk.ru/todo/';

  static const list = 'list';
  static const item = 'list/{id}';
}

@RestApi(baseUrl: ApiUrl.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

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
