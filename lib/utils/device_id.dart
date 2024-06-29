import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceId() async {
  String? deviceId;
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    deviceId = info.id;
  } else if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    deviceId = info.identifierForVendor;
  }
  return deviceId ?? 'UNKNOWN_DEVICE';
}
