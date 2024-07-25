// Package imports:
import 'package:device_info_plus/device_info_plus.dart';

class AndroidDeviceInfo {
  static late final int sdkVersion;

  static Future<void> init() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    sdkVersion = deviceInfo.version.sdkInt;
  }
}
