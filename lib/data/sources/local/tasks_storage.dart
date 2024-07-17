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

  List<Task> getTasks() {
    try {
      final data = prefs.getString(tasksKey);
      if (data == null) return [];
      return jsonDecode(data).map<Task>((json) => Task.fromJson(json)).toList();
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return [];
    }
  }

  void setTasks(List<Task> tasks) {
    final data = jsonEncode(tasks);
    prefs.setString(tasksKey, data);
  }

  int getRevision() {
    try {
      return prefs.getInt(revisionKey) ?? 0;
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return 0;
    }
  }

  void setRevision(int revision) => prefs.setInt(revisionKey, revision);
}
