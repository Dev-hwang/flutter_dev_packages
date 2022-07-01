import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'date_time_utils.dart';
import 'system_utils.dart';

class NotificationUtils {
  NotificationUtils._internal() {
    tz.initializeTimeZones();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings(),
      macOS: MacOSInitializationSettings(),
    );
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationsPlugin.initialize(initializationSettings);

    _notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'flutter_notification',
        '푸시 알림',
        channelDescription:
            '앱에서 발생하는 푸시 알림을 받습니다. 중요도를 변경할 경우 알림을 받지 못할 수도 있습니다.',
        priority: Priority.max,
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
      macOS: MacOSNotificationDetails(),
    );
  }

  static final instance = NotificationUtils._internal();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  late NotificationDetails _notificationDetails;
  int _notificationIdCount = 100;

  /// 알림을 1회 알린다.
  Future<int> oneShot({
    int? id,
    required String title,
    String? body,
    bool sound = true,
    bool wakeLock = true,
  }) async {
    final int uniqueId = id ?? _generateUniqueNotificationId();

    await _notificationsPlugin.show(
      uniqueId,
      title,
      body,
      _notificationDetails,
      payload: sound ? 'Default_Sound' : '',
    );

    // Wake up screen for Android Platform
    if (wakeLock) {
      SystemUtils.instance.wakeLockScreen();
    }

    return Future.value(uniqueId);
  }

  /// [scheduleDate]에 알림을 알린다.
  Future<int> schedule({
    int? id,
    required String title,
    String? body,
    required DateTime scheduleDate,
    bool sound = true,
    bool wakeLock = true,
  }) async {
    final int uniqueId = id ?? _generateUniqueNotificationId();

    await _notificationsPlugin.zonedSchedule(
      uniqueId,
      title,
      body,
      tz.TZDateTime.from(scheduleDate, tz.local),
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: sound ? 'Default_Sound' : '',
    );

    // Wake up screen for Android Platform
    if (wakeLock) {
      final difference = scheduleDate.difference(DateTime.now());
      Future.delayed(
        Duration(milliseconds: difference.inMilliseconds),
        SystemUtils.instance.wakeLockScreen,
      );
    }

    return Future.value(uniqueId);
  }

  /// [id]에 해당하는 알림을 취소한다.
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// 모든 알림을 취소한다.
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    _notificationIdCount = 100;
  }

  /// 고유 알림 ID를 생성한다.
  int _generateUniqueNotificationId() {
    final dateTimeString = DateTimeUtils.instance
        .dateTimeToString(DateTime.now(), pattern: 'ddHHmmss');

    return int.tryParse(dateTimeString) ?? 0 + _notificationIdCount++;
  }
}
