import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/ui/button/models/button_size.dart';
import 'package:flutter_dev_packages/ui/button/simple_button.dart';

enum DialogButtonStyle {
  flat,
  android,
  ios,
}

class CustomDialog {
  const CustomDialog({
    this.title,
    this.titleStyle,
    TextAlign? titleAlign,
    this.titleWidget,
    this.titleBackgroundColor,
    EdgeInsetsGeometry? titlePadding,
    this.content,
    this.contentStyle,
    TextAlign? contentAlign,
    this.contentWidget,
    this.contentBackgroundColor,
    EdgeInsetsGeometry? contentPadding,
    this.backgroundColor,
    double? borderRadius,
    this.dividerColor,
    double? dividerThickness,
    EdgeInsetsGeometry? dividerMargin,
    DialogButtonStyle? buttonStyle,
    this.positiveButtonColor,
    this.negativeButtonColor,
    String? positiveButtonText,
    String? negativeButtonText,
    this.positiveButtonTextStyle,
    this.negativeButtonTextStyle,
    bool? expandedWidth,
    bool? showingButton,
    bool? dismissible,
    bool? willCloseWhenPositiveButtonPressed,
    bool? willCloseWhenNegativeButtonPressed,
    this.onDismiss,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
  })  : titleAlign = titleAlign ?? TextAlign.start,
        titlePadding =
            titlePadding ?? const EdgeInsets.fromLTRB(12, 14, 12, 14),
        contentAlign = contentAlign ?? TextAlign.start,
        contentPadding = title == null
            ? contentPadding ?? const EdgeInsets.fromLTRB(24, 24, 24, 24)
            : contentPadding ?? const EdgeInsets.fromLTRB(12, 18, 12, 18),
        borderRadius = borderRadius ?? 4,
        dividerThickness = dividerThickness ?? 0.5,
        dividerMargin = dividerMargin ?? const EdgeInsets.all(0),
        buttonStyle = buttonStyle ?? DialogButtonStyle.flat,
        positiveButtonText = positiveButtonText ?? '확인',
        negativeButtonText = negativeButtonText ?? '취소',
        expandedWidth = expandedWidth ?? true,
        showingButton = showingButton ?? true,
        dismissible = dismissible ?? false,
        willCloseWhenPositiveButtonPressed =
            willCloseWhenPositiveButtonPressed ?? true,
        willCloseWhenNegativeButtonPressed =
            willCloseWhenNegativeButtonPressed ?? true;

  final String? title;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final Widget? titleWidget;
  final Color? titleBackgroundColor;
  final EdgeInsetsGeometry titlePadding;

  final String? content;
  final TextStyle? contentStyle;
  final TextAlign contentAlign;
  final Widget? contentWidget;
  final Color? contentBackgroundColor;
  final EdgeInsetsGeometry contentPadding;

  final Color? backgroundColor;
  final double borderRadius;

  final Color? dividerColor;
  final double dividerThickness;
  final EdgeInsetsGeometry dividerMargin;

  final DialogButtonStyle buttonStyle;
  final Color? positiveButtonColor;
  final Color? negativeButtonColor;
  final String positiveButtonText;
  final String negativeButtonText;
  final TextStyle? positiveButtonTextStyle;
  final TextStyle? negativeButtonTextStyle;

  final bool expandedWidth;
  final bool showingButton;
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          insetPadding: const EdgeInsets.all(20),
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          backgroundColor: backgroundColor ??
              Theme.of(context).dialogTheme.backgroundColor ??
              Theme.of(context).colorScheme.background,
          content: SingleChildScrollView(
            child: SizedBox(
              width: expandedWidth ? MediaQuery.of(context).size.width : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildDialogHeader(context),
                  _buildDialogBody(context),
                  _buildDialogFooter(context)
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) => onDismiss?.call());
  }

  Widget _buildDialogHeader(BuildContext context) {
    if (title == null && titleWidget == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: titlePadding,
          decoration: BoxDecoration(
            color: titleBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          child: titleWidget ??
              Text(
                title ?? '',
                style: Theme.of(context)
                    .dialogTheme
                    .titleTextStyle
                    ?.merge(titleStyle),
                textAlign: titleAlign,
              ),
        ),
        Container(
          margin: dividerMargin,
          height: dividerThickness,
          color: dividerColor ?? Theme.of(context).dividerColor,
        ),
      ],
    );
  }

  Widget _buildDialogBody(BuildContext context) {
    return Container(
      padding: contentPadding,
      color: contentBackgroundColor,
      child: contentWidget ??
          Text(
            content ?? '',
            style: Theme.of(context)
                .dialogTheme
                .contentTextStyle
                ?.merge(contentStyle),
            textAlign: contentAlign,
          ),
    );
  }

  Widget _buildDialogFooter(BuildContext context) {
    if (!showingButton) {
      return const SizedBox.shrink();
    }

    final buttonList = <Widget>[];
    if (onNegativeButtonPressed != null) {
      buttonList.add(_buildNegativeButton(context));
      if (buttonStyle == DialogButtonStyle.flat) {
        buttonList.add(const SizedBox(width: 4.0));
      } else if (buttonStyle == DialogButtonStyle.android) {
        buttonList.add(const SizedBox(width: 6.0));
      } else if (buttonStyle == DialogButtonStyle.ios) {
        buttonList.add(const SizedBox(width: 0.5));
      }
    }
    buttonList.add(_buildPositiveButton(context));

    switch (buttonStyle) {
      case DialogButtonStyle.flat:
        return Container(
          margin: const EdgeInsets.only(right: 8.0, bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttonList,
          ),
        );
      case DialogButtonStyle.android:
        return Container(
          height: ButtonSize.materialLarge.minHeight,
          margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttonList,
          ),
        );
      default:
        return Container(
          height: ButtonSize.appleLarge.minHeight,
          decoration: BoxDecoration(
            color: dividerColor ?? Theme.of(context).dividerColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 0.5),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buttonList,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildPositiveButton(BuildContext context) {
    final buttonTextTheme = Theme.of(context).textTheme.button;
    TextStyle? buttonTextStyle;
    if (buttonStyle == DialogButtonStyle.android) {
      buttonTextStyle = buttonTextTheme?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary);
    } else {
      buttonTextStyle = buttonTextTheme?.copyWith(
          color: Theme.of(context).colorScheme.onBackground);
    }
    buttonTextStyle = buttonTextStyle?.merge(positiveButtonTextStyle);

    final buttonRadius = Radius.circular(borderRadius);

    buttonCallback() {
      onPositiveButtonPressed?.call();
      if (willCloseWhenPositiveButtonPressed) {
        Navigator.of(context).pop();
      }
    }

    switch (buttonStyle) {
      case DialogButtonStyle.flat:
        return TextButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(positiveButtonText, style: buttonTextStyle),
          ),
          onPressed: buttonCallback,
        );
      case DialogButtonStyle.android:
        return Expanded(
          child: SimpleButton(
            child: Text(positiveButtonText, style: buttonTextStyle),
            color: positiveButtonColor,
            borderRadius: BorderRadius.circular(2),
            onPressed: buttonCallback,
          ),
        );
      default:
        return Expanded(
          child: SimpleButton(
            child: Text(positiveButtonText, style: buttonTextStyle),
            color: positiveButtonColor ??
                backgroundColor ??
                Theme.of(context).dialogTheme.backgroundColor ??
                Theme.of(context).colorScheme.background,
            borderRadius: onNegativeButtonPressed != null
                ? BorderRadius.only(bottomRight: buttonRadius)
                : BorderRadius.only(
                    bottomRight: buttonRadius,
                    bottomLeft: buttonRadius,
                  ),
            elevation: 0,
            onPressed: buttonCallback,
          ),
        );
    }
  }

  Widget _buildNegativeButton(BuildContext context) {
    final buttonTextTheme = Theme.of(context).textTheme.button;
    TextStyle? buttonTextStyle;
    if (buttonStyle == DialogButtonStyle.android) {
      buttonTextStyle = buttonTextTheme?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary);
    } else {
      buttonTextStyle = buttonTextTheme?.copyWith(
          color: Theme.of(context).colorScheme.onBackground);
    }
    buttonTextStyle = buttonTextStyle?.merge(negativeButtonTextStyle);

    final buttonRadius = Radius.circular(borderRadius);

    buttonCallback() {
      onNegativeButtonPressed?.call();
      if (willCloseWhenNegativeButtonPressed) {
        Navigator.of(context).pop();
      }
    }

    switch (buttonStyle) {
      case DialogButtonStyle.flat:
        return TextButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(negativeButtonText, style: buttonTextStyle),
          ),
          onPressed: buttonCallback,
        );
      case DialogButtonStyle.android:
        return Expanded(
          child: SimpleButton(
            child: Text(negativeButtonText, style: buttonTextStyle),
            color: negativeButtonColor,
            borderRadius: BorderRadius.circular(2),
            onPressed: buttonCallback,
          ),
        );
      default:
        return Expanded(
          child: SimpleButton(
            child: Text(negativeButtonText, style: buttonTextStyle),
            color: negativeButtonColor ??
                backgroundColor ??
                Theme.of(context).dialogTheme.backgroundColor ??
                Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(bottomLeft: buttonRadius),
            elevation: 0,
            onPressed: buttonCallback,
          ),
        );
    }
  }
}
