import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const needToSyncKey = 'needToSync';

class SyncStorage {
  final SharedPreferences prefs;

  SyncStorage(this.prefs);

  final _logger = GetIt.I<Logger>();

  bool? loadNeedToSync() {
    try {
      return prefs.getBool(needToSyncKey);
    } catch (error, stackTrace) {
      _logger.e(error, stackTrace: stackTrace);
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
