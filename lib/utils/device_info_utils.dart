import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfoUtils {
  DeviceInfoUtils._internal();
  static final instance = DeviceInfoUtils._internal();

  /// 디바이스 정보를 가져온다.
  Future<Map<String, dynamic>> readDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        return readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        return readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else {
        return {'Error:': 'This platform cannot read the device information.'};
      }
    } on PlatformException {
      return {'Error:': 'Failed to get platform version.'};
    }
  }

  /// Android 플랫폼 디바이스 정보를 읽는다.
  Map<String, dynamic> readAndroidDeviceInfo(AndroidDeviceInfo info) {
    return {
      'version.securityPatch': info.version.securityPatch,
      'version.sdkInt': info.version.sdkInt,
      'version.release': info.version.release,
      'version.previewSdkInt': info.version.previewSdkInt,
      'version.incremental': info.version.incremental,
      'version.codename': info.version.codename,
      'version.baseOS': info.version.baseOS,
      'board': info.board,
      'bootloader': info.bootloader,
      'brand': info.brand,
      'device': info.device,
      'display': info.display,
      'fingerprint': info.fingerprint,
      'hardware': info.hardware,
      'host': info.host,
      'id': info.id,
      'manufacturer': info.manufacturer,
      'model': info.model,
      'product': info.product,
      'supported32BitAbis': info.supported32BitAbis,
      'supported64BitAbis': info.supported64BitAbis,
      'supportedAbis': info.supportedAbis,
      'tags': info.tags,
      'type': info.type,
      'isPhysicalDevice': info.isPhysicalDevice,
      'androidId': info.androidId,
      'systemFeatures': info.systemFeatures,
    };
  }

  /// iOS 플랫폼 디바이스 정보를 읽는다.
  Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo info) {
    return {
      'name': info.name,
      'systemName': info.systemName,
      'systemVersion': info.systemVersion,
      'model': info.model,
      'localizedModel': info.localizedModel,
      'identifierForVendor': info.identifierForVendor,
      'isPhysicalDevice': info.isPhysicalDevice,
      'utsname.sysname:': info.utsname.sysname,
      'utsname.nodename:': info.utsname.nodename,
      'utsname.release:': info.utsname.release,
      'utsname.version:': info.utsname.version,
      'utsname.machine:': info.utsname.machine,
    };
  }
}
