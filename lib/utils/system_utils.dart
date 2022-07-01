import 'dart:io';

import 'package:flutter/services.dart';

class SystemUtils {
  SystemUtils._internal();
  static final instance = SystemUtils._internal();

  static const _channel = MethodChannel('flutter_dev_packages/system');

  /// 앱을 최소화한다.
  void minimize() {
    if (Platform.isAndroid) {
      _channel.invokeMethod('minimize');
    }
  }

  /// 앱을 강제 종료한다.
  void forcePop() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  /// 절전 상태의 화면을 깨운다.
  void wakeLockScreen() {
    if (Platform.isAndroid) {
      _channel.invokeMethod('wakeLockScreen');
    }
  }
}
