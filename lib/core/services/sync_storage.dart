import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const needToSyncKey = 'needToSync';

class SyncStorage {
  final SharedPreferences prefs;

  SyncStorage(this.prefs);

  bool? loadNeedToSync() {
    try {
      return prefs.getBool(needToSyncKey);
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  void saveNeedToSync(bool? needToSync) {
    if (needToSync == null) {
      prefs.remove(needToSyncKey);
    } else {
      prefs.setBool(needToSyncKey, needToSync);
    }
  }
}
