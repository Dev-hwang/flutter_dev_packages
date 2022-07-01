import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  /// Android: Calendar
  /// iOS: Calendar (Events)
  calendar,

  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  camera,

  /// Android: Contacts
  /// iOS: AddressBook
  contacts,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  location,

  /// When running on Android < Q: Fine and Coarse Location
  /// When running on Android Q and above: Background Location Permission
  /// iOS: CoreLocation - Always
  locationAlways,

  /// Android: None
  /// iOS: MPMediaLibrary
  mediaLibrary,

  /// Android: Microphone
  /// iOS: Microphone
  microphone,

  /// Android: Phone
  /// iOS: Nothing
  phone,

  /// Android: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  photos,

  /// Android: Nothing
  /// iOS: Reminders
  reminders,

  /// Android: Body Sensors
  /// iOS: CoreMotion
  sensors,

  /// Android: Sms
  /// iOS: Nothing
  sms,

  /// Android: Microphone
  /// iOS: Speech
  speech,

  /// Android: External Storage
  /// iOS: Access to folders like `Documents` or `Downloads`.
  storage,

  /// Android: Notification
  /// iOS: Notification
  notification,

  /// Android: Allows an application to access any geographic locations
  /// persisted in the user's shared collection.
  accessMediaLocation,

  /// When running on Android Q and above: Activity Recognition
  /// When running on Android < Q: Nothing
  /// iOS: Nothing
  activityRecognition,

  /// iOS 13 and above: The authorization state of Core Bluetooth manager.
  /// When running < iOS 13 or Android this is always allowed.
  bluetooth,

  /// Android: Allows the user to look for Bluetooth devices (e.g. BLE peripherals).
  /// iOS: Nothing
  bluetoothScan,

  /// Android: Allows the user to make this device discoverable to other Bluetooth devices.
  /// iOS: Nothing
  bluetoothAdvertise,

  /// Android: Allows the user to connect with already paired Bluetooth devices.
  /// iOS: Nothing
  bluetoothConnect,

  /// Android: Allow Drawing Top-Level View
  /// iOS: Nothing
  systemAlertWindow,

  /// The unknown permission only used for return type, never requested
  unknown,
}

extension PermissionTypeExtension on PermissionType {
  /// 권한 아이콘을 반환한다.
  Icon permissionIcon({Color? color}) {
    IconData iconData;
    switch (this) {
      case PermissionType.calendar:
        iconData = Icons.calendar_today;
        break;
      case PermissionType.camera:
        iconData = Icons.camera;
        break;
      case PermissionType.contacts:
        iconData = Icons.perm_contact_cal;
        break;
      case PermissionType.location:
        iconData = Icons.location_pin;
        break;
      case PermissionType.locationAlways:
        iconData = Icons.location_pin;
        break;
      case PermissionType.mediaLibrary:
        iconData = Icons.music_note;
        break;
      case PermissionType.microphone:
        iconData = Icons.mic;
        break;
      case PermissionType.phone:
        iconData = Icons.call;
        break;
      case PermissionType.photos:
        iconData = Icons.photo;
        break;
      case PermissionType.reminders:
        iconData = Icons.schedule;
        break;
      case PermissionType.sensors:
        iconData = Icons.sensors;
        break;
      case PermissionType.sms:
        iconData = Icons.message;
        break;
      case PermissionType.speech:
        iconData = Icons.mic;
        break;
      case PermissionType.storage:
        iconData = Icons.sd_storage;
        break;
      case PermissionType.notification:
        iconData = Icons.notifications;
        break;
      case PermissionType.accessMediaLocation:
        iconData = Icons.sd_storage;
        break;
      case PermissionType.activityRecognition:
        iconData = Icons.accessibility;
        break;
      case PermissionType.bluetooth:
        iconData = Icons.bluetooth;
        break;
      case PermissionType.bluetoothScan:
        iconData = Icons.bluetooth_searching;
        break;
      case PermissionType.bluetoothAdvertise:
        iconData = Icons.bluetooth_searching;
        break;
      case PermissionType.bluetoothConnect:
        iconData = Icons.bluetooth_connected;
        break;
      case PermissionType.systemAlertWindow:
        iconData = Icons.palette;
        break;
      case PermissionType.unknown:
        iconData = Icons.warning_outlined;
    }

    return Icon(iconData, color: color);
  }

  /// 권한 이름을 반환한다.
  String permissionName({bool necessary = false}) {
   String nameStr;
   switch (this) {
     case PermissionType.calendar:
       nameStr = '캘린더';
       break;
     case PermissionType.camera:
       nameStr = '카메라';
       break;
     case PermissionType.contacts:
       nameStr = '연락처';
       break;
     case PermissionType.location:
       nameStr = '위치';
       break;
     case PermissionType.locationAlways:
       nameStr = '위치';
       break;
     case PermissionType.mediaLibrary:
       nameStr = '미디어';
       break;
     case PermissionType.microphone:
       nameStr = '마이크';
       break;
     case PermissionType.phone:
       nameStr = '전화';
       break;
     case PermissionType.photos:
       nameStr = '갤러리';
       break;
     case PermissionType.reminders:
       nameStr = '리마인더';
       break;
     case PermissionType.sensors:
       nameStr = '센서';
       break;
     case PermissionType.sms:
       nameStr = '메시지';
       break;
     case PermissionType.speech:
       nameStr = '음성 인식';
       break;
     case PermissionType.storage:
       nameStr = '저장소';
       break;
     case PermissionType.notification:
       nameStr = '알림';
       break;
     case PermissionType.accessMediaLocation:
       nameStr = '외부 저장소';
       break;
     case PermissionType.activityRecognition:
       nameStr = '활동 인식';
       break;
     case PermissionType.bluetooth:
       nameStr = '블루투스';
       break;
     case PermissionType.bluetoothScan:
       nameStr = '블루투스 검색';
       break;
     case PermissionType.bluetoothAdvertise:
       nameStr = '블루투스 광고';
       break;
     case PermissionType.bluetoothConnect:
       nameStr = '블루투스 연결';
       break;
     case PermissionType.systemAlertWindow:
       nameStr = '다른 앱 위에 표시';
       break;
     case PermissionType.unknown:
       nameStr = '알 수 없음';
   }

   return nameStr + (necessary ? ' (필수)' : '');
  }

  /// 권한 설명을 반환한다.
  String permissionDesc() {
    switch (this) {
      case PermissionType.calendar:
        return '캘린더 앱에 접근하기 위해 필요합니다.';
      case PermissionType.camera:
        return '카메라에 접근하기 위해 필요합니다.';
      case PermissionType.contacts:
        return '연락처 앱에 접근하기 위해 필요합니다.';
      case PermissionType.location:
        return '위치 서비스를 제공하기 위해 필요합니다.';
      case PermissionType.locationAlways:
        return '백그라운드에서 위치 서비스를 제공하기 위해 필요합니다.';
      case PermissionType.mediaLibrary:
        return '미디어 라이브러리에 접근하기 위해 필요합니다.';
      case PermissionType.microphone:
        return '마이크에 접근하기 위해 필요합니다.';
      case PermissionType.phone:
        return '디바이스 상태를 읽거나 통화 기능을 제공하기 위해 필요합니다.';
      case PermissionType.photos:
        return '갤러리에 접근하기 위해 필요합니다.';
      case PermissionType.reminders:
        return '리마인더에 접근하기 위해 필요합니다.';
      case PermissionType.sensors:
        return '센서에 접근하기 위해 필요합니다.';
      case PermissionType.sms:
        return '메시지 앱에 접근하기 위해 필요합니다.';
      case PermissionType.speech:
        return '음성 인식 서비스를 제공하기 위해 필요합니다.';
      case PermissionType.storage:
        return '스마트폰 내부 저장소에 접근하기 위해 필요합니다.';
      case PermissionType.notification:
        return '푸시 알림 서비스를 제공하기 위해 필요합니다.';
      case PermissionType.accessMediaLocation:
        return '스마트폰 외부 저장소에 접근하기 위해 필요합니다.';
      case PermissionType.activityRecognition:
        return '활동 인식 서비스를 제공하기 위해 필요합니다.';
      case PermissionType.bluetooth:
        return '블루투스 장치에 접근하기 위해 필요합니다.';
      case PermissionType.bluetoothScan:
        return '블루투스 장치를 검색하기 위해 필요합니다.';
      case PermissionType.bluetoothAdvertise:
        return '블루투스 광고 서비스를 제공하기 위해 필요합니다.';
      case PermissionType.bluetoothConnect:
        return '블루투스 장치와 연결하기 위해 필요합니다.';
      case PermissionType.systemAlertWindow:
        return '다른 앱 위에 컨텐츠를 표시하기 위해 필요합니다.';
      case PermissionType.unknown:
        return '알려지지 않은 권한입니다.';
    }
  }

  /// [Permission] 객체로 변환한다.
  Permission toPermissionObj() {
    switch (this) {
      case PermissionType.calendar:
        return Permission.calendar;
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.contacts:
        return Permission.contacts;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.locationAlways:
        return Permission.locationAlways;
      case PermissionType.mediaLibrary:
        return Permission.mediaLibrary;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.phone:
        return Permission.phone;
      case PermissionType.photos:
        return Permission.photos;
      case PermissionType.reminders:
        return Permission.reminders;
      case PermissionType.sensors:
        return Permission.sensors;
      case PermissionType.sms:
        return Permission.sms;
      case PermissionType.speech:
        return Permission.speech;
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.notification:
        return Permission.notification;
      case PermissionType.accessMediaLocation:
        return Permission.accessMediaLocation;
      case PermissionType.activityRecognition:
        return Permission.activityRecognition;
      case PermissionType.bluetooth:
        return Permission.bluetooth;
      case PermissionType.bluetoothScan:
        return Permission.bluetoothScan;
      case PermissionType.bluetoothAdvertise:
        return Permission.bluetoothAdvertise;
      case PermissionType.bluetoothConnect:
        return Permission.bluetoothConnect;
      case PermissionType.systemAlertWindow:
        return Permission.unknown;
      case PermissionType.unknown:
        return Permission.unknown;
    }
  }
}
