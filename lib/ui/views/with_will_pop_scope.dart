import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/ui/dialog/android_toast.dart';
import 'package:flutter_dev_packages/utils/system_utils.dart';

class WithWillPopScope extends StatefulWidget {
  const WithWillPopScope({
    Key? key,
    this.moveBackground = false,
    this.message,
    required this.child,
  }) : super(key: key);

  /// 백그라운드 이동 여부
  final bool moveBackground;

  /// 앱 종료 확인 메시지
  final String? message;

  /// 자식 위젯
  final Widget child;

  @override
  State<WithWillPopScope> createState() => _WithWillPopScopeState();
}

class _WithWillPopScopeState extends State<WithWillPopScope> {
  DateTime _backPressedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final currDateTime = DateTime.now();
        final diffDuration = currDateTime.difference(_backPressedDateTime);
        if (diffDuration > const Duration(seconds: 2)) {
          _backPressedDateTime = currDateTime;

          if (widget.message == null) {
            AndroidToast(
              message: widget.moveBackground
                  ? '한 번 더 누르면 백그라운드로 전환됩니다.'
                  : '한 번 더 누르면 종료됩니다.',
            ).show();
          } else {
            AndroidToast(message: widget.message!).show();
          }

          return Future.value(false);
        }

        if (widget.moveBackground) {
          SystemUtils.instance.minimize();
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: widget.child,
    );
  }
}
