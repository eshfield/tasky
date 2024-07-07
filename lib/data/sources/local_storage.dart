import 'dart:convert';

import 'package:app/domain/models/task.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const tasksKey = 'tasks';
const revisionKey = 'revision';

class LocalStorage {
  final SharedPreferences prefs;

  LocalStorage(this.prefs);

  List<Task>? loadTasks() {
    try {
      final data = prefs.getString(tasksKey);
      if (data == null) return null;
      return jsonDecode(data).map<Task>((json) => Task.fromJson(json)).toList();
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final data = jsonEncode(tasks);
    await prefs.setString(tasksKey, data);
  }

  int? loadRevision() {
    try {
      return prefs.getInt(revisionKey);
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> saveRevision(int? revision) async {
    if (revision == null) {
      await prefs.remove(revisionKey);
    } else {
      await prefs.setInt(revisionKey, revision);
    }
  }
}
