import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/flutter_dev_packages.dart';

import 'example_page.dart';

/// 앱에서 사용되는 권한 목록입니다.
const List<PermissionData> kAppPermissions = [
  PermissionData(
    permissionType: PermissionType.locationAlways,
    isNecessary: true,
  ),
  PermissionData(
    permissionType: PermissionType.storage,
    isNecessary: true,
  ),
  PermissionData(permissionType: PermissionType.notification),
];

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<InitResult> _initFunction() async {
    InitResult initResult;
    try {
      // 초기화 작업
      initResult = const InitResult(complete: true);
    } catch (error, stackTrace) {
      // 오류 핸들링
      initResult =
          InitResult(complete: false, error: error, stackTrace: stackTrace);
    }

    // complete true 리턴 시 nextPage 이동
    return initResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PermissionCheckPage(
        permissions: kAppPermissions,
        appIconAssetsPath: 'assets/images/ic_launcher.png',
        initFunction: _initFunction,
        nextPage: const ExamplePage(),
      ),
    );
  }
}
