import 'package:json_annotation/json_annotation.dart';

class UnixTimestampJsonConverter implements JsonConverter<DateTime, int> {
  const UnixTimestampJsonConverter();

  @override
  DateTime fromJson(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  @override
  int toJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch ~/ 1000;
}
