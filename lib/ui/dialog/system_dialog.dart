import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SystemDialog {
  const SystemDialog({
    this.title,
    this.titleStyle,
    required this.content,
    this.contentStyle,
    String? positiveButtonText,
    String? negativeButtonText,
    this.positiveButtonTextStyle,
    this.negativeButtonTextStyle,
    bool? dismissible,
    bool? willCloseWhenPositiveButtonPressed,
    bool? willCloseWhenNegativeButtonPressed,
    this.onDismiss,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
  })  : positiveButtonText = positiveButtonText ?? '확인',
        negativeButtonText = negativeButtonText ?? '취소',
        dismissible = dismissible ?? false,
        willCloseWhenPositiveButtonPressed =
            willCloseWhenPositiveButtonPressed ?? true,
        willCloseWhenNegativeButtonPressed =
            willCloseWhenNegativeButtonPressed ?? true;

  final String? title;
  final TextStyle? titleStyle;

  final String content;
  final TextStyle? contentStyle;

  final String positiveButtonText;
  final String negativeButtonText;
  final TextStyle? positiveButtonTextStyle;
  final TextStyle? negativeButtonTextStyle;

  final bool dismissible;
  final bool willCloseWhenPositiveButtonPressed;
  final bool willCloseWhenNegativeButtonPressed;

  final VoidCallback? onDismiss;
  final VoidCallback? onPositiveButtonPressed;
  final VoidCallback? onNegativeButtonPressed;

  Future<void> show(BuildContext context) async {
    await showModal<void>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(
        barrierDismissible: dismissible,
      ),
      builder: (BuildContext context) {
        Widget titleWidget;
        EdgeInsetsGeometry? titlePadding;
        if (title == null) {
          titleWidget = const SizedBox.shrink();
          titlePadding = const EdgeInsets.all(0);
        } else {
          titleWidget = Text(
            title!,
            style: Theme.of(context).dialogTheme.titleTextStyle?.merge(titleStyle),
          );
        }

        final contentWidget = Text(
          content,
          style: Theme.of(context).dialogTheme.contentTextStyle?.merge(contentStyle),
        );
        final contentPadding = title == null
            ? const EdgeInsets.all(24)
            : const EdgeInsets.fromLTRB(24, 20, 24, 24);

        final actionButtons = <Widget>[];
        if (onNegativeButtonPressed != null) {
          actionButtons.add(_buildActionButton(context, positive: false));
        }
        actionButtons.add(_buildActionButton(context, positive: true));

        if (Platform.isAndroid) {
          return AlertDialog(
            title: titleWidget,
            titlePadding: titlePadding,
            content: contentWidget,
            contentPadding: contentPadding,
            actions: actionButtons,
          );
        } else {
          return CupertinoAlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: actionButtons,
          );
        }
      },
    ).then((_) => onDismiss?.call());
  }

  Widget _buildActionButton(BuildContext context, {bool positive = true}) {
    final child = positive
        ? Text(positiveButtonText, style: positiveButtonTextStyle)
        : Text(negativeButtonText, style: negativeButtonTextStyle);

    final onPressed = positive
        ? () {
            onPositiveButtonPressed?.call();
            if (willCloseWhenPositiveButtonPressed) {
              Navigator.of(context).pop();
            }
          }
        : () {
            onNegativeButtonPressed?.call();
            if (willCloseWhenNegativeButtonPressed) {
              Navigator.of(context).pop();
            }
          };

    if (Platform.isAndroid) {
      return TextButton(child: child, onPressed: onPressed);
    } else {
      return CupertinoDialogAction(
        isDefaultAction: positive,
        child: child,
        onPressed: onPressed,
      );
    }
  }
}
