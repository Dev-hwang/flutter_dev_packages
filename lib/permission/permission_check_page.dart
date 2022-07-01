import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/permission/models/permission_type.dart';
import 'package:flutter_dev_packages/permission/permission_utils.dart';
import 'package:flutter_dev_packages/ui/button/models/button_size.dart';
import 'package:flutter_dev_packages/ui/button/simple_button.dart';
import 'package:flutter_dev_packages/ui/dialog/system_dialog.dart';
import 'package:flutter_dev_packages/utils/exception_utils.dart';
import 'package:flutter_dev_packages/utils/system_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/permission_data.dart';
import 'models/permissions_status.dart';

/// 초기화 함수
typedef InitFunction = Future<InitResult> Function();

/// 스플래시 화면 빌더
typedef SplashViewBuilder = Widget Function();

/// 권한 화면 머리말 빌더
typedef PermissionViewHeaderBuilder = Widget Function();

/// 권한 목록 아이템 빌더
typedef PermissionListItemBuilder = Widget Function(PermissionData permission);

/// 권한을 요청해도 되는지 확인하는 콜백
typedef WillRequestPermissionsCallback = Future<bool> Function(List<PermissionData> permissions);

class InitResult {
  const InitResult({
    required this.complete,
    this.error,
    this.stackTrace,
    this.showsError = true,
    this.unknownErrorDesc,
  });

  /// 초기화 완료 여부
  final bool complete;

  /// 오류
  final dynamic error;

  /// 오류 리포트
  final dynamic stackTrace;

  /// 오류 보여주기 여부
  final bool showsError;

  /// 알 수 없는 오류에 대한 설명
  final String? unknownErrorDesc;
}

class PermissionCheckPage extends StatefulWidget {
  const PermissionCheckPage({
    Key? key,
    required this.permissions,
    this.appIconAssetsPath,
    this.requestMessageStyle,
    this.permissionIconColor,
    this.permissionNameStyle,
    this.permissionDescStyle,
    this.splashViewBuilder,
    this.permissionViewHeaderBuilder,
    this.permissionListItemBuilder,
    this.splashDuration = const Duration(seconds: 1),
    this.willRequestPermissions,
    required this.initFunction,
    required this.nextPage,
  }) : super(key: key);

  /// 앱 사용에 필요한 권한 목록
  final List<PermissionData> permissions;

  /// 권한 화면 머리말에 표시할 앱 아이콘 경로
  final String? appIconAssetsPath;

  /// 권한 요청 메시지 스타일
  final TextStyle? requestMessageStyle;

  /// 권한 아이콘 색상
  final Color? permissionIconColor;

  /// 권한 이름 텍스트 스타일
  final TextStyle? permissionNameStyle;

  /// 권한 설명 텍스트 스타일
  final TextStyle? permissionDescStyle;

  /// 스플래시 화면 빌더
  final SplashViewBuilder? splashViewBuilder;

  /// 권한 화면 머리말 빌더
  final PermissionViewHeaderBuilder? permissionViewHeaderBuilder;

  /// 권한 목록 아이템 빌더
  final PermissionListItemBuilder? permissionListItemBuilder;

  /// 스플래시 지연 시간
  final Duration splashDuration;

  /// 권한을 요청해도 되는지 확인하는 콜백
  final WillRequestPermissionsCallback? willRequestPermissions;

  /// 초기화 함수
  final InitFunction initFunction;

  /// 초기화 및 권한 허용 후 이동할 다음 페이지
  final Widget nextPage;

  @override
  State<PermissionCheckPage> createState() => _PermissionCheckPageState();
}

class _PermissionCheckPageState extends State<PermissionCheckPage>
    with TickerProviderStateMixin {
  final _filteredPermissions = <PermissionData>[];
  final _splashViewVisibleStateNotifier = ValueNotifier<bool>(true);

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isRequestingPermissions = false;

  void _initAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  void _checkPermissions(List<PermissionData> permissions) async {
    final prefs = await SharedPreferences.getInstance();
    final isCheckFirst = prefs.getBool('isCheckFirstPermissions') ?? true;

    PermissionUtils.instance.getPermissionsStatus(permissions).then((result) {
      if (permissions.isEmpty || (result.isGranted && !isCheckFirst)) {
        _registerSplashTimer();
        return;
      }

      _splashViewVisibleStateNotifier.value = false;
    });
  }

  void _requestPermissions(List<PermissionData> permissions) async {
    if (_isRequestingPermissions) return;
    _isRequestingPermissions = true;

    if (widget.willRequestPermissions != null &&
        await widget.willRequestPermissions?.call(permissions) == false) {
      _isRequestingPermissions = false;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCheckFirstPermissions', false);

    PermissionUtils.instance.requestPermissions(permissions).then((result) {
      if (permissions.isEmpty || result.isGranted) {
        _registerSplashTimer();
        return;
      }

      _showDialogWhenRequiredPermissionsAreDenied(result);
    }).whenComplete(() {
      _isRequestingPermissions = false;
    });
  }

  void _registerSplashTimer() async {
    _splashViewVisibleStateNotifier.value = true;

    final initResult = await widget.initFunction();
    if (initResult.complete) {
      Timer(widget.splashDuration, () async {
        await _animationController.reverse();
        final route = MaterialPageRoute(builder: (_) => widget.nextPage);
        Navigator.pushReplacement(context, route);
      });
    } else if (!initResult.complete && initResult.showsError) {
      final errorReason = ExceptionUtils.instance.getReason(
        initResult.error,
        unknownIssueDesc: initResult.unknownErrorDesc,
      );
      _showDialogWhenShowsErrorIsTrue(errorReason);
    }
  }

  void _showDialogWhenRequiredPermissionsAreDenied(PermissionsStatus status) {
    final deniedPermissions = status.deniedPermissions;
    final sb = StringBuffer();
    sb.write('어플리케이션을 사용하려면 필수 표시된 권한(');
    for (var i = 0; i < deniedPermissions.length; i++) {
      if (i != 0) sb.write(', ');
      sb.write(deniedPermissions[i].permissionType.permissionName());
    }
    sb.write(')을 허용해야 합니다.');

    SystemDialog(content: sb.toString()).show(context);
  }

  void _showDialogWhenShowsErrorIsTrue(String errorReason) {
    SystemDialog(
      content: '앱 초기화에 실패하여 앱을 시작할 수 없습니다. [err: $errorReason]\n\n다시 시도하시겠습니까?',
      positiveButtonText: '재시도',
      negativeButtonText: '종료',
      onPositiveButtonPressed: () => _registerSplashTimer(),
      onNegativeButtonPressed: () => SystemUtils.instance.forcePop(),
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    final permissions =
        PermissionUtils.instance.filterByPlatform(widget.permissions);
    _filteredPermissions.addAll(permissions);
    _checkPermissions(permissions);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _splashViewVisibleStateNotifier,
      builder: (_, value, __) {
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              transitionType: SharedAxisTransitionType.horizontal,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: value ? _buildSplashView() : _buildPermissionView(),
        );
      },
    );
  }

  Widget _buildSplashView() {
    Widget splashView;
    if (widget.splashViewBuilder != null) {
      splashView = widget.splashViewBuilder!();
    } else {
      splashView = Center(
        child: widget.appIconAssetsPath == null
            ? const Icon(Icons.android_rounded, size: 80)
            : Image.asset(widget.appIconAssetsPath!, height: 80),
      );
    }

    return FadeTransition(opacity: _animation, child: splashView);
  }

  Widget _buildPermissionView() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildPermissionViewHeader(),
          Expanded(child: _buildPermissionListView()),
          _buildPermissionRequestButton(),
        ],
      ),
    );
  }

  Widget _buildPermissionViewHeader() {
    if (widget.permissionViewHeaderBuilder != null) {
      return widget.permissionViewHeaderBuilder!();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
          child: widget.appIconAssetsPath == null
              ? const Icon(Icons.android_rounded, size: 50)
              : Image.asset(widget.appIconAssetsPath!, height: 50),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: Text(
            '어플리케이션 사용을 위해\n다음 접근 권한을 허용해주세요.',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.merge(widget.requestMessageStyle),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildPermissionListView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredPermissions.length,
      itemBuilder: (_, index) =>
          _buildPermissionListItem(_filteredPermissions[index]),
    );
  }

  Widget _buildPermissionListItem(PermissionData permission) {
    if (widget.permissionListItemBuilder != null) {
      return widget.permissionListItemBuilder!(permission);
    }

    final permissionNameStyle = Theme.of(context)
        .textTheme
        .subtitle1
        ?.copyWith(height: 1.2)
        .merge(widget.permissionNameStyle);
    final permissionDescStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.merge(widget.permissionDescStyle);
    final permissionIconColor = widget.permissionIconColor ?? permissionNameStyle?.color;

    final permissionIcon = permission.permissionType.permissionIcon(color: permissionIconColor);
    final permissionName = permission.permissionType.permissionName(necessary: permission.isNecessary);
    final permissionDesc = permission.description ?? permission.permissionType.permissionDesc();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          permissionIcon,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(permissionName, style: permissionNameStyle),
                const SizedBox(height: 2),
                Text(permissionDesc, style: permissionDescStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequestButton() {
    return SimpleButton(
      buttonSize: ButtonSize.materialXLarge,
      child: const Text('확인'),
      onPressed: () => _requestPermissions(_filteredPermissions),
    );
  }

  @override
  void dispose() {
    _splashViewVisibleStateNotifier.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
