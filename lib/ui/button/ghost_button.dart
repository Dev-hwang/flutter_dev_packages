import 'package:flutter/material.dart';

import 'models/button_size.dart';

class GhostButton extends StatelessWidget {
  const GhostButton({
    Key? key,
    this.buttonSize = ButtonSize.materialMedium,
    required this.child,
    this.overlayColor,
    this.borderSide,
    this.disabledBorderSide,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.materialTapTargetSize,
    this.onPressed,
    this.onLongPress,
  }) : super(key: key);

  final ButtonSize buttonSize;
  final Widget child;
  final Color? overlayColor;
  final BorderSide? borderSide;
  final BorderSide? disabledBorderSide;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    BorderSide _borderSide;
    if (onPressed == null && onLongPress == null) {
      _borderSide = disabledBorderSide ??
          BorderSide(color: Theme.of(context).disabledColor);
    } else {
      _borderSide = borderSide ??
          BorderSide(color: Theme.of(context).colorScheme.primary);
    }

    final shape = RoundedRectangleBorder(
      side: _borderSide,
      borderRadius: borderRadius,
    );

    final style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).disabledColor;
        }
        return Theme.of(context).colorScheme.primary;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return overlayColor ?? Theme.of(context).splashColor;
        }
        return null;
      }),
      elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all(padding ?? buttonSize.padding),
      shape: MaterialStateProperty.all(shape),
      tapTargetSize: materialTapTargetSize,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: buttonSize.minWidth,
        minHeight: buttonSize.minHeight,
      ),
      child: ElevatedButton(
        style: style,
        child: child,
        onPressed: onPressed,
        onLongPress: onLongPress,
      ),
    );
  }
}
