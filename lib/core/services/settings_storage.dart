import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const showDoneTasksKey = 'showDoneTasks';

class SettingsStorage {
  final SharedPreferences prefs;

  SettingsStorage(this.prefs);

  bool? loadShowDoneTasks() {
    try {
      return prefs.getBool(showDoneTasksKey);
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  void saveShowDoneTasks(bool? showDoneTasks) {
    if (showDoneTasks == null) {
      prefs.remove(showDoneTasksKey);
    } else {
      prefs.setBool(showDoneTasksKey, showDoneTasks);
    }
  }
}
