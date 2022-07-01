import 'permission_type.dart';

class PermissionData {
  const PermissionData({
    required this.permissionType,
    this.description,
    this.isNecessary = false,
  });

  /// 권한 종류
  final PermissionType permissionType;

  /// 권한 설명
  final String? description;

  /// 권한 필수 여부
  final bool isNecessary;
}
