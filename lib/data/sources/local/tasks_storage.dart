import 'dart:convert';

import 'package:app/domain/entities/task.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const tasksKey = 'tasks';
const revisionKey = 'revision';

class TasksStorage {
  final SharedPreferences prefs;

  TasksStorage(this.prefs);

  List<Task>? loadTasks() {
    try {
      final data = prefs.getString(tasksKey);
      if (data == null) return null;
      return jsonDecode(data).map<Task>((json) => Task.fromJson(json)).toList();
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  void saveTasks(List<Task> tasks) {
    final data = jsonEncode(tasks);
    prefs.setString(tasksKey, data);
  }

  int? loadRevision() {
    try {
      return prefs.getInt(revisionKey);
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  void saveRevision(int? revision) {
    if (revision == null) {
      prefs.remove(revisionKey);
    } else {
      prefs.setInt(revisionKey, revision);
    }
  }
}
