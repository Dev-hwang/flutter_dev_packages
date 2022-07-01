import 'package:flutter/material.dart';

import 'models/button_size.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    Key? key,
    this.buttonSize = ButtonSize.materialMedium,
    required this.child,
    this.color,
    this.disabledColor,
    this.elevation = 2,
    this.disabledElevation = 0,
    this.overlayColor,
    this.borderSide = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.materialTapTargetSize,
    required this.onPressed,
    this.onLongPress,
  })  : assert(elevation >= 0),
        assert(disabledElevation >= 0),
        super(key: key);

  final ButtonSize buttonSize;
  final Widget child;
  final Color? color;
  final Color? disabledColor;
  final double elevation;
  final double disabledElevation;
  final Color? overlayColor;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      side: borderSide,
      borderRadius: borderRadius,
    );

    final style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledColor ??
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12);
        }
        return color ?? Theme.of(context).colorScheme.primary;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).colorScheme.onSurface.withOpacity(0.38);
        }
        return Theme.of(context).colorScheme.onPrimary;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return overlayColor ??
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.24);
        }
        return null;
      }),
      elevation: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledElevation;
        }
        return elevation;
      }),
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
