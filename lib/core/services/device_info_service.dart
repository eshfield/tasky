import 'dart:io';

import 'package:app/core/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  late final String deviceId;

  bool get isTablet {
    final display = PlatformDispatcher.instance.views.first.display;
    return (display.size.shortestSide / display.devicePixelRatio) > 600;
  }

  Future<void> init() async {
    final deviceInfo = DeviceInfoPlugin();
    String? id;
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      id = info.id;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      id = info.identifierForVendor;
    }
    deviceId = id ?? unknownDeviceId;
  }
}
