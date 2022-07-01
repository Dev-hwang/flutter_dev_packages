import 'package:flutter/material.dart';

class WithScrollUpButton extends StatefulWidget {
  const WithScrollUpButton({
    Key? key,
    required this.listView,
    this.buttonColor,
    this.buttonOpacity = 0.8,
    this.buttonIcon = const Icon(Icons.keyboard_arrow_up),
    this.buttonMini = false,
    this.buttonMargin = const EdgeInsets.all(12),
  })  : assert(buttonOpacity >= 0.0 && buttonOpacity <= 1.0),
        super(key: key);

  /// [ScrollController]를 포함하는 리스트뷰
  final ListView listView;

  /// 버튼 색상
  final Color? buttonColor;

  /// 버튼 투명도
  final double buttonOpacity;

  /// 버튼 아이콘
  final Icon buttonIcon;

  /// 작은 버튼 사용 여부
  final bool buttonMini;

  /// 버튼 마진
  final EdgeInsetsGeometry buttonMargin;

  @override
  State<WithScrollUpButton> createState() => _WithScrollUpButtonState();
}

class _WithScrollUpButtonState extends State<WithScrollUpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  bool _visibleScrollUpButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_animationController);

    widget.listView.controller?.addListener(() {
      if (widget.listView.controller?.offset == 0.0) {
        if (_visibleScrollUpButton) {
          _animationController.reverse();
          _visibleScrollUpButton = false;
        }
      } else {
        if (!_visibleScrollUpButton) {
          _animationController.forward();
          _visibleScrollUpButton = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        widget.listView,
        _buildScrollUpButton(),
      ],
    );
  }

  Widget _buildScrollUpButton() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: widget.buttonMargin,
        child: Opacity(
          opacity: widget.buttonOpacity,
          child: FloatingActionButton(
            backgroundColor:
                widget.buttonColor ?? Theme.of(context).colorScheme.primary,
            mini: widget.buttonMini,
            child: widget.buttonIcon,
            onPressed: () {
              widget.listView.controller?.animateTo(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
              );
            },
          ),
        ),
      ),
    );
  }
}
