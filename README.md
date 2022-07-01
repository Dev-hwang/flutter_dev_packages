This plugin includes components, utilities, and more to make it easier to develop the Flutter app.

## Directory

``` bash
├── logger
│   ├── models
│   │   ├── log_event.dart
│   │   └── log_level.dart
│   ├── logger.dart
│   └── printer.dart
├── network
│   ├── exception
│   │   └── api_exception.dart
│   ├── models
│   │   ├── charset.dart
│   │   ├── http_media_type.dart
│   │   ├── http_request_method.dart
│   │   └── network_protocol.dart
│   └── rest_api.dart
├── permission
│   ├── models
│   │   ├── permission_data.dart
│   │   ├── permission_type.dart
│   │   └── permissions_status.dart
│   ├── permission_check_page.dart
│   └── permission_utils.dart
├── ui
│   ├── button
│   │   ├── models
│   │   │   └── button_size.dart
│   │   ├── date_picker_button.dart
│   │   ├── drop_down_button.dart
│   │   ├── ghost_button.dart
│   │   └── simple_button.dart
│   ├── component
│   │   ├── gradient_app_bar.dart
│   │   └── speech_bubble.dart
│   ├── dialog
│   │   ├── android_toast.dart
│   │   ├── custom_dialog.dart
│   │   ├── modal_date_picker.dart
│   │   └── system_dialog.dart
│   └── views
│       ├── with_drag_detector.dart
│       ├── with_progress_screen.dart
│       ├── with_scroll_up_button.dart
│       ├── with_theme_manager.dart
│       └── with_will_pop_scope.dart
├── utils
│   ├── date_time_utils.dart
│   ├── device_info_utils.dart
│   ├── exception_utils.dart
│   ├── notification_utils.dart
│   ├── system_utils.dart
│   ├── text_format_utils.dart
│   └── web_image_utils.dart
└── flutter_dev_packages.dart
```

## Getting started

To use this plugin, add `flutter_dev_packages` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  flutter_dev_packages:
    git:
      url: https://github.com/Dev-hwang/flutter_dev_packages.git
      ref: master
```

## Usage

플러그인에 포함된 패키지나 유틸리티를 사용하려면 플랫폼별 초기 설정이 필요하다.

### :baby_chick: logger package

1. [sentry.io](https://sentry.io/welcome/) 회원가입을 진행한다.

2. 프로젝트를 생성하고 DSN 값을 얻는다.

3. 프로젝트의 `main` 함수에 아래와 같이 `Sentry` 플러그인을 초기화한다.

``` dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/flutter_dev_packages.dart';

const String kSentryDsn = 'https://80ab98a9a0b448e0b591d2d5db20c47b@o332735.ingest.sentry.io/0';

void main() {
  runZonedGuarded(() async {
    await Sentry.init((options) {
      options.dsn = kSentryDsn;
    });

    runApp(const ExampleApp());
  }, (error, stackTrace) async {
    await Logger.f('FATAL EXCEPTION', error: error, stackTrace: stackTrace);
  });
}
```

### :baby_chick: network package

network 패키지 사용 시 아래 권한 추가 필요

#### Android

/android/app/src/main/AndroidManifest.xml

``` xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS

/ios/Runner/info.plist

``` xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
  <key>NSAllowsArbitraryLoadsInWebContent</key>
  <true/>
</dict>
```

### :baby_chick: permission package

permission 패키지 사용 시 필요 권한 추가 필요

#### Android

/android/app/src/main/AndroidManifest.xml

``` xml
<!-- 캘린더 -->
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />

<!-- 카메라 -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- 연락처 -->
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
<uses-permission android:name="android.permission.GET_ACCOUNTS" />

<!-- 저장소 -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- SMS -->
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_WAP_PUSH" />
<uses-permission android:name="android.permission.RECEIVE_MMS" />

<!-- PHONE -->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.ADD_VOICEMAIL" />
<uses-permission android:name="android.permission.USE_SIP" />
<uses-permission android:name="android.permission.READ_CALL_LOG" />
<uses-permission android:name="android.permission.WRITE_CALL_LOG" />
<uses-permission android:name="android.permission.BIND_CALL_REDIRECTION_SERVICE" />

<!-- 위치 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

<!-- 마이크 -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />

<!-- 미디어 -->
<uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION" />

<!-- 모션센서 -->
<uses-permission android:name="android.permission.BODY_SENSORS" />

<!-- 활동인식 -->
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />

<!-- 블루투스 -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />

<!-- Overlay -->
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

#### iOS

/ios/Runner/info.plist

``` xml
<!-- 캘린더 -->
<key>NSCalendarsUsageDescription</key>
<string></string>

<!-- 카메라 -->
<key>NSCameraUsageDescription</key>
<string></string>

<!-- 연락처 -->
<key>NSContactsUsageDescription</key>
<string></string>

<!-- 위치 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string></string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string></string>
<key>NSLocationUsageDescription</key>
<string></string>
<key>NSLocationAlwaysUsageDescription</key>
<string></string>

<!-- 마이크 -->
<key>NSMicrophoneUsageDescription</key>
<string></string>

<!-- 갤러리 -->
<key>NSPhotoLibraryUsageDescription</key>
<string></string>

<!-- 미디어 -->
<key>NSAppleMusicUsageDescription</key>
<string></string>
<key>kTCCServiceMediaLibrary</key>
<string></string>

<!-- 모션센서 -->
<key>NSMotionUsageDescription</key>
<string></string>

<!-- 음성인식 -->
<key>NSSpeechRecognitionUsageDescription</key>
<string></string>

<!-- 리마인더 -->
<key>NSRemindersUsageDescription</key>
<string></string>
```

/ios/Podfile

``` xml
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        ## 아래 표를 참고하여 사용할 권한에 대한 매크로를 추가한다.
        'PERMISSION_LOCATION=1',
        'PERMISSION_NOTIFICATIONS=1'
      ]
    end

    flutter_additional_ios_build_settings(target)
  end
end
```

| Permission                        | Info.plist                                                                                                    | Macro                                |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| PermissionType.calendar           | NSCalendarsUsageDescription                                                                                   | PERMISSION_EVENTS                    |
| PermissionType.reminders          | NSRemindersUsageDescription                                                                                   | PERMISSION_REMINDERS                 |
| PermissionType.contacts           | NSContactsUsageDescription                                                                                    | PERMISSION_CONTACTS                  |
| PermissionType.camera             | NSCameraUsageDescription                                                                                      | PERMISSION_CAMERA                    |
| PermissionType.microphone         | NSMicrophoneUsageDescription                                                                                  | PERMISSION_MICROPHONE                |
| PermissionType.speech             | NSSpeechRecognitionUsageDescription                                                                           | PERMISSION_SPEECH_RECOGNIZER         |
| PermissionType.photos             | NSPhotoLibraryUsageDescription                                                                                | PERMISSION_PHOTOS                    |
| PermissionType.location           | NSLocationUsageDescription, NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationWhenInUseUsageDescription | PERMISSION_LOCATION                  |
| PermissionType.notification       | PermissionGroupNotification                                                                                   | PERMISSION_NOTIFICATIONS             |
| PermissionType.mediaLibrary       | NSAppleMusicUsageDescription, kTCCServiceMediaLibrary                                                         | PERMISSION_MEDIA_LIBRARY             |
| PermissionType.sensors            | NSMotionUsageDescription                                                                                      | PERMISSION_SENSORS                   |
| PermissionType.bluetooth          | NSBluetoothAlwaysUsageDescription, NSBluetoothPeripheralUsageDescription                                      | PERMISSION_BLUETOOTH                 |

### :baby_chick: notification_utils

#### Android

/android/app/src/main/AndroidManifest.xml

``` xml
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

/android/app/proguard-rules.pro

``` xml
-keep class com.dexterous.** { *; }
```

#### iOS

/ios/Runner/AppDelegate.swift

``` xml
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 노티피케이션 대리자를 등록하세요.
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### :baby_chick: date_picker_button

/project/pubspec.yaml

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```

/project/lib/main.dart

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@override
Widget build(BuildContext context) {
  return MaterialApp(
    localizationsDelegates: [
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en'),
      const Locale('ko'),
    ],
    ...
  );
}
```

## Prepare release

### :star2: keystore 생성 및 서명 구성

#### 1. 터미널에 아래 명령어를 입력하여 keystore 파일을 생성한다.

맥/리눅스에서는 아래 명령어를 사용하세요:
``` text
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

윈도우에서는 아래 명령어를 사용하세요:
``` text
keytool -genkey -v -keystore c:/Users/USER_NAME/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

#### 2. /android/key.properties 파일을 생성하고 아래 내용을 입력한다.

``` text
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<key store 파일 위치, 예) /Users/<user name>/key.jks>
```

#### 3. /android/app/build.gradle 파일에 아래 코드를 추가한다.

``` text
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // 기본 코드 생략..

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### :star2: 코드 난독화

#### 1. /android/app/proguard-rules.pro 파일을 생성하고 아래 내용을 입력한다.

``` text
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
```

#### 2. /android/app/build.gradle 파일에 아래 코드를 추가한다.
``` text
android {
    // 기본 코드 생략..

    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            signingConfig signingConfigs.release
            proguardFiles getDefaultProguardFile(
                    'proguard-android-optimize.txt'),
                    'proguard-rules.pro'
        }

        debug {
            minifyEnabled false
            proguardFiles getDefaultProguardFile(
                    'proguard-android-optimize.txt'),
                    'proguard-rules.pro'
        }
    }
}
```

자세한 내용은 [공식 홈페이지](https://flutter-ko.dev/docs/deployment/android) 참조
