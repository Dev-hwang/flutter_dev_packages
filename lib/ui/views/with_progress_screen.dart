import 'package:flutter/material.dart';

class WithProgressScreen extends StatelessWidget {
  const WithProgressScreen({
    Key? key,
    this.barrierColor = Colors.black,
    this.barrierOpacity = 0.5,
    this.indicator = const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xCCFFFFFF)),
    ),
    this.indicatorOffset,
    required this.showsProgress,
    required this.child,
  })  : assert(barrierOpacity >= 0.0 && barrierOpacity <= 1.0),
        super(key: key);

  /// 배경색
  final Color barrierColor;

  /// 배경색 투명도
  final double barrierOpacity;

  /// 인디케이터
  final Widget indicator;

  /// 인디케이터 오프셋
  final Offset? indicatorOffset;

  /// 프로그레스 보여주기 여부
  final bool showsProgress;

  /// 자식 위젯
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[child];
    if (showsProgress) {
      children.addAll([
        Opacity(
          opacity: barrierOpacity,
          child: ModalBarrier(color: barrierColor, dismissible: false),
        ),
        indicatorOffset == null
            ? Center(child: indicator)
            : Positioned(
                left: indicatorOffset?.dx ?? 0,
                top: indicatorOffset?.dy ?? 0,
                child: indicator,
              ),
      ]);
    }

    return Stack(children: children);
  }
}
