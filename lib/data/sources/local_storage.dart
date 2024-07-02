import 'dart:convert';

import 'package:app/domain/models/task.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const tasksKey = 'tasks';
const revisionKey = 'revision';
const needToSyncKey = 'needToSync';

class LocalStorage {
  final SharedPreferences prefs;

  LocalStorage(this.prefs);

  final _logger = GetIt.I<Logger>();

  List<Task>? loadTasks() {
    try {
      final data = prefs.getString(tasksKey);
      if (data == null) return null;
      return jsonDecode(data).map<Task>((json) => Task.fromJson(json)).toList();
    } catch (error, stackTrace) {
      _logger.e(error, stackTrace: stackTrace);
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
      _logger.e(error, stackTrace: stackTrace);
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

  bool? loadNeedToSync() {
    try {
      return prefs.getBool(needToSyncKey);
    } catch (error, stackTrace) {
      _logger.e(error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> saveNeedToSync(bool? needToSync) async {
    if (needToSync == null) {
      await prefs.remove(needToSyncKey);
    } else {
      await prefs.setBool(needToSyncKey, needToSync);
    }
  }
}
