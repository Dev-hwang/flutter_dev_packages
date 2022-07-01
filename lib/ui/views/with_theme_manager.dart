import 'package:flutter/material.dart';

/// 자식 위젯 빌더
typedef WidgetBuilder = Widget Function(
  BuildContext context,
  ThemeData themeData,
);

class WithThemeManager extends StatefulWidget {
  const WithThemeManager({
    Key? key,
    required this.themeData,
    required this.builder,
  }) : super(key: key);

  /// 앱 테마 데이터
  final ThemeData themeData;

  /// 자식 위젯 빌더
  final WidgetBuilder builder;

  @override
  State<WithThemeManager> createState() => _WithThemeManagerState();

  /// [WithThemeManager] 위젯 상태를 반한환다.
  static _WithThemeManagerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_WithThemeManagerState>();
}

class _WithThemeManagerState extends State<WithThemeManager> {
  late ThemeData _themeData;

  /// 현재 적용된 테마 데이터를 가져온다.
  ThemeData get themeData => _themeData;

  /// 테마 데이터를 설정한다.
  void setThemeData(ThemeData themeData) {
    setState(() {
      _themeData = themeData;
    });
  }

  @override
  void initState() {
    super.initState();
    _themeData = widget.themeData;
  }

  @override
  void didUpdateWidget(covariant WithThemeManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.themeData;
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _themeData);
}
