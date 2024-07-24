import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const needToSyncKey = 'needToSync';

class SyncStorage {
  final SharedPreferences prefs;

  SyncStorage(this.prefs);

  bool getNeedToSync() {
    try {
      return prefs.getBool(needToSyncKey) ?? false;
    } catch (error, stackTrace) {
      Logger().e(error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return false;
    }
  }

  void setNeedToSync(bool needToSync) =>
      prefs.setBool(needToSyncKey, needToSync);
}
