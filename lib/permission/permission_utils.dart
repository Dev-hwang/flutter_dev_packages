import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/permission_data.dart';
import 'models/permission_type.dart';
import 'models/permissions_status.dart';

class PermissionUtils {
  PermissionUtils._internal();
  static final instance = PermissionUtils._internal();

  static const _channel = MethodChannel('flutter_dev_packages/permission');

  /// 권한 상태를 가져옵니다.
  Future<PermissionsStatus> getPermissionsStatus(List<PermissionData> permissions) async {
    final filteredPermissions =
        await filterByVersion(filterByPlatform(permissions));

    final grantedPermissions = <PermissionData>[];
    final deferredPermissions = <PermissionData>[];
    final deniedPermissions = <PermissionData>[];
    PermissionType permissionType;
    Permission permission;
    for (final p in filteredPermissions) {
      permissionType = p.permissionType;
      permission = permissionType.toPermissionObj();

      if (permissionType == PermissionType.systemAlertWindow) {
        if (await canDrawOverlays()) {
          grantedPermissions.add(p);
        } else {
          if (p.isNecessary) {
            deniedPermissions.add(p);
          } else {
            deferredPermissions.add(p);
          }
        }
      } else {
        if (permissionType == PermissionType.locationAlways) {
          permission = Permission.location;
        }

        if (await permission.isGranted) {
          grantedPermissions.add(p);
        } else {
          if (p.isNecessary) {
            deniedPermissions.add(p);
          } else {
            deferredPermissions.add(p);
          }
        }
      }
    }

    return PermissionsStatus(
      grantedPermissions: grantedPermissions,
      deferredPermissions: deferredPermissions,
      deniedPermissions: deniedPermissions,
    );
  }

  /// 권한을 요청합니다.
  Future<PermissionsStatus> requestPermissions(List<PermissionData> permissions) async {
    final filteredPermissions =
        await filterByVersion(filterByPlatform(permissions));

    PermissionType permissionType;
    Permission permission;
    bool willRequestOverlayPermission = false;
    for (final p in filteredPermissions) {
      permissionType = p.permissionType;
      permission = permissionType.toPermissionObj();

      if (Platform.isAndroid &&
          permissionType == PermissionType.locationAlways) {
        // Android 11(API 수준 30) 이상일 때는 location 권한 먼저 요청한다.
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVers = androidInfo.version.sdkInt ?? 0;
        final isLocationPermissionGranted = androidVers >= 30
            ? await Permission.location.request().isGranted
            : true;

        if (isLocationPermissionGranted) {
          await Permission.locationAlways.request();
        }
      } else if (permissionType == PermissionType.systemAlertWindow) {
        if (!await canDrawOverlays() && p.isNecessary) {
          willRequestOverlayPermission = true;
        }
      } else {
        await permission.request();
      }
    }

    // Overlay 권한 요청
    if (willRequestOverlayPermission) {
      await requestOverlays();
    }

    return getPermissionsStatus(permissions);
  }

  /// 특정 플랫폼에서 사용되지 않는 [permissions]을 필터링한다.
  List<PermissionData> filterByPlatform(List<PermissionData> permissions) {
    final filteredPermissions = <PermissionData>[];
    PermissionType permissionType;
    for (final permission in permissions) {
      permissionType = permission.permissionType;

      if (Platform.isAndroid) {
        if (permissionType == PermissionType.mediaLibrary ||
            permissionType == PermissionType.photos ||
            permissionType == PermissionType.reminders) {
          continue;
        }
      } else {
        if (permissionType == PermissionType.phone ||
            permissionType == PermissionType.sms ||
            permissionType == PermissionType.activityRecognition ||
            permissionType == PermissionType.systemAlertWindow ||
            permissionType == PermissionType.bluetoothScan ||
            permissionType == PermissionType.bluetoothAdvertise ||
            permissionType == PermissionType.bluetoothConnect) {
          continue;
        }
      }

      filteredPermissions.add(permission);
    }

    return filteredPermissions;
  }

  /// 특정 버전에서 사용되지 않는 [permissions]을 필터링한다.
  Future<List<PermissionData>> filterByVersion(List<PermissionData> permissions) async {
    final filteredPermissions = <PermissionData>[];
    PermissionType permissionType;
    for (final permission in permissions) {
      permissionType = permission.permissionType;

      if (Platform.isAndroid &&
          permissionType == PermissionType.activityRecognition) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVers = androidInfo.version.sdkInt ?? 0;
        if (androidVers < 29) {
          continue;
        }
      }

      filteredPermissions.add(permission);
    }

    return filteredPermissions;
  }

  /// Overlay 권한이 허용되었는지 확인한다.
  Future<bool> canDrawOverlays() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('canDrawOverlays');
    } else {
      return Future.value(false);
    }
  }

  /// Overlay 권한을 요청한다.
  Future<bool> requestOverlays() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('requestOverlays');
    } else {
      return Future.value(false);
    }
  }

  /// 위치 서비스 활성화 여부를 확인한다.
  Future<bool> isLocationServiceEnabled() async {
    return await _channel.invokeMethod('isLocationServiceEnabled');
  }

  /// 위치 서비스 설정 페이지를 연다.
  Future<bool> openLocationServiceSettings() async {
    return await _channel.invokeMethod('openLocationServiceSettings');
  }
}
