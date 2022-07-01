import 'package:flutter_dev_packages/permission/models/permission_data.dart';

class PermissionsStatus {
  const PermissionsStatus({
    required this.grantedPermissions,
    required this.deferredPermissions,
    required this.deniedPermissions,
  });

  /// 허용된 권한 목록입니다.
  final List<PermissionData> grantedPermissions;

  /// 연기된 권한 목록입니다.
  final List<PermissionData> deferredPermissions;

  /// 거부된 권한 목록입니다.
  final List<PermissionData> deniedPermissions;

  /// 전체 권한 목록입니다.
  List<PermissionData> get permissions =>
      grantedPermissions + deferredPermissions + deniedPermissions;

  /// [permissions]이 모두 허용되었는지 여부를 나타냅니다.
  bool get isGranted => deniedPermissions.isEmpty;

  /// [permissions]에 거부된 권한이 있는지 여부를 나타냅니다.
  bool get isDenied => deniedPermissions.isNotEmpty;
}
