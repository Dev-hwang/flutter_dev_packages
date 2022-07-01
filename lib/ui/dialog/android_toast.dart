import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AndroidToastLength {
  short,
  long,
}

extension AndroidToastLengthExtension on AndroidToastLength {
  Toast toFlutterToastLength() {
    switch (this) {
      case AndroidToastLength.long:
        return Toast.LENGTH_LONG;
      default:
        return Toast.LENGTH_SHORT;
    }
  }
}

enum AndroidToastGravity {
  top,
  bottom,
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  centerLeft,
  centerRight,
  snackbar,
}

extension AndroidToastGravityExtension on AndroidToastGravity {
  ToastGravity toFlutterToastGravity() {
    switch (this) {
      case AndroidToastGravity.top:
        return ToastGravity.TOP;
      case AndroidToastGravity.center:
        return ToastGravity.CENTER;
      case AndroidToastGravity.topLeft:
        return ToastGravity.TOP_LEFT;
      case AndroidToastGravity.topRight:
        return ToastGravity.TOP_RIGHT;
      case AndroidToastGravity.bottomLeft:
        return ToastGravity.BOTTOM_LEFT;
      case AndroidToastGravity.bottomRight:
        return ToastGravity.BOTTOM_RIGHT;
      case AndroidToastGravity.centerLeft:
        return ToastGravity.CENTER_LEFT;
      case AndroidToastGravity.centerRight:
        return ToastGravity.CENTER_RIGHT;
      case AndroidToastGravity.snackbar:
        return ToastGravity.SNACKBAR;
      default:
        return ToastGravity.BOTTOM;
    }
  }
}

class AndroidToast {
  const AndroidToast({
    required this.message,
    this.fontSize = 15,
    this.fontColor = Colors.white,
    this.backgroundColor = Colors.black54,
    this.gravity = AndroidToastGravity.bottom,
    this.length = AndroidToastLength.short,
  });

  final String message;
  final double fontSize;
  final Color fontColor;
  final Color backgroundColor;
  final AndroidToastGravity gravity;
  final AndroidToastLength length;

  Future<bool?> show() async {
    return Fluttertoast.showToast(
      msg: message,
      fontSize: fontSize,
      textColor: fontColor,
      backgroundColor: backgroundColor,
      gravity: gravity.toFlutterToastGravity(),
      toastLength: length.toFlutterToastLength(),
    );
  }
}
