import 'dart:math';

import 'package:flutter/material.dart';

enum NipDirection {
  leftTop,
  leftCenter,
  leftBottom,
  rightTop,
  rightBottom,
}

class SpeechBubbleStyle {
  const SpeechBubbleStyle({
    this.color,
    this.shadowColor,
    this.radius = const Radius.circular(4.0),
    this.nipWidth = 8.0,
    this.nipHeight = 10.0,
    this.nipOffset = 0.0,
    this.nipRadius = 1.0,
    this.stick = false,
  })  : assert(nipWidth > 0.0),
        assert(nipHeight > 0.0),
        assert(nipOffset >= 0.0),
        assert(nipRadius >= 0.0),
        assert(nipRadius <= nipWidth / 2 && nipRadius <= nipHeight / 2);

  final Color? color;
  final Color? shadowColor;
  final Radius radius;
  final double nipWidth;
  final double nipHeight;
  final double nipOffset;
  final double nipRadius;
  final bool stick;
}

class SpeechBubbleClipper extends CustomClipper<Path> {
  SpeechBubbleClipper({
    required this.padding,
    required this.radius,
    required this.nipDirection,
    required this.nipWidth,
    required this.nipHeight,
    required this.nipOffset,
    required this.nipRadius,
    required this.stick,
  })  : assert(nipWidth > 0.0),
        assert(nipHeight > 0.0),
        assert(nipOffset >= 0.0),
        assert(nipRadius >= 0.0),
        assert(nipRadius <= nipWidth / 2 && nipRadius <= nipHeight / 2),
        super() {
    _startOffset = _endOffset = nipWidth;

    var k = nipHeight / nipWidth;
    var a = atan(k);

    _nipCX = (nipRadius + sqrt(nipRadius * nipRadius * (1 + k * k))) / k;
    var nipStickOffset = (_nipCX - nipRadius).floorToDouble();

    _nipCX -= nipStickOffset;
    _nipCY = nipRadius;
    _nipPX = _nipCX - nipRadius * sin(a);
    _nipPY = _nipCY + nipRadius * cos(a);
    _startOffset -= nipStickOffset;
    _endOffset -= nipStickOffset;

    if (stick) _endOffset = 0.0;
  }

  final EdgeInsets padding;
  final Radius radius;
  final NipDirection nipDirection;
  final double nipWidth;
  final double nipHeight;
  final double nipOffset;
  final double nipRadius;
  final bool stick;

  late double _startOffset;
  late double _endOffset;
  late double _nipCX;
  late double _nipCY;
  late double _nipPX;
  late double _nipPY;

  get edgeInsets {
    if (nipDirection == NipDirection.leftTop ||
        nipDirection == NipDirection.leftCenter ||
        nipDirection == NipDirection.leftBottom) {
      return EdgeInsets.only(
        left: _startOffset + padding.left,
        top: padding.top,
        right: _endOffset + padding.right,
        bottom: padding.bottom,
      );
    } else {
      return EdgeInsets.only(
        left: _endOffset + padding.left,
        top: padding.top,
        right: _startOffset + padding.right,
        bottom: padding.bottom,
      );
    }
  }

  @override
  Path getClip(Size size) {
    var radiusX = radius.x;
    var radiusY = radius.y;
    var maxRadiusX = size.width / 2.0;
    var maxRadiusY = size.height / 2.0;

    if (radiusX > maxRadiusX) {
      radiusY *= maxRadiusX / radiusX;
      radiusX = maxRadiusX;
    }
    if (radiusY > maxRadiusY) {
      radiusX *= maxRadiusY / radiusY;
      radiusY = maxRadiusY;
    }

    var path = Path();

    switch (nipDirection) {
      case NipDirection.leftTop:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));

        path.moveTo(_startOffset + radiusX, nipOffset);
        path.lineTo(_startOffset + radiusX, nipOffset + nipHeight);
        path.lineTo(_startOffset, nipOffset + nipHeight);
        if (nipRadius == 0) {
          path.lineTo(0, nipOffset);
        } else {
          path.lineTo(_nipPX, nipOffset + _nipPY);
          path.arcToPoint(
            Offset(_nipCX, nipOffset),
            radius: Radius.circular(nipRadius),
          );
        }
        path.close();
        break;

      case NipDirection.leftCenter:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));

        path.moveTo(_startOffset + radiusX, size.height / 2 - nipHeight);
        path.lineTo(_startOffset + radiusX, size.height / 2 + nipHeight);
        path.lineTo(_startOffset, size.height / 2 + nipHeight);
        if (nipRadius == 0) {
          path.lineTo(0, size.height / 2 + nipHeight);
        } else {
          path.lineTo(_nipPX, size.height / 2 + _nipPY);
          path.arcToPoint(
            Offset(_nipCX, nipOffset + size.height / 2),
            radius: Radius.circular(nipRadius),
          );
        }
        path.close();
        break;

      case NipDirection.leftBottom:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));

        Path path2 = Path();
        path2.moveTo(_startOffset + radiusX, size.height - nipOffset);
        path2.lineTo(
            _startOffset + radiusX, size.height - nipOffset - nipHeight);
        path2.lineTo(_startOffset, size.height - nipOffset - nipHeight);
        if (nipRadius == 0) {
          path2.lineTo(0, size.height - nipOffset);
        } else {
          path2.lineTo(_nipPX, size.height - nipOffset - _nipPY);
          path2.arcToPoint(
            Offset(_nipCX, size.height - nipOffset),
            radius: Radius.circular(nipRadius),
            clockwise: false,
          );
        }
        path2.close();

        path.addPath(path2, const Offset(0, 0));
        path.addPath(path2, const Offset(0, 0)); // Magic!
        break;

      case NipDirection.rightTop:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));

        Path path2 = Path();
        path2.moveTo(size.width - _startOffset - radiusX, nipOffset);
        path2.lineTo(
            size.width - _startOffset - radiusX, nipOffset + nipHeight);
        path2.lineTo(size.width - _startOffset, nipOffset + nipHeight);
        if (nipRadius == 0) {
          path2.lineTo(size.width, nipOffset);
        } else {
          path2.lineTo(size.width - _nipPX, nipOffset + _nipPY);
          path2.arcToPoint(
            Offset(size.width - _nipCX, nipOffset),
            radius: Radius.circular(nipRadius),
            clockwise: false,
          );
        }
        path2.close();

        path.addPath(path2, const Offset(0, 0));
        path.addPath(path2, const Offset(0, 0)); // Magic!
        break;

      case NipDirection.rightBottom:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));

        path.moveTo(
            size.width - _startOffset - radiusX, size.height - nipOffset);
        path.lineTo(size.width - _startOffset - radiusX,
            size.height - nipOffset - nipHeight);
        path.lineTo(
            size.width - _startOffset, size.height - nipOffset - nipHeight);
        if (nipRadius == 0) {
          path.lineTo(size.width, size.height - nipOffset);
        } else {
          path.lineTo(size.width - _nipPX, size.height - nipOffset - _nipPY);
          path.arcToPoint(
            Offset(size.width - _nipCX, size.height - nipOffset),
            radius: Radius.circular(nipRadius),
          );
        }
        path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SpeechBubblePainter extends CustomPainter {
  SpeechBubblePainter({
    required this.elevation,
    required this.color,
    required this.shadowColor,
    required this.clipper,
  }) : assert(elevation >= 0);

  final double elevation;
  final Color color;
  final Color shadowColor;
  final CustomClipper<Path> clipper;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (elevation != 0.0) {
      canvas.drawShadow(clipper.getClip(size), shadowColor, elevation, false);
    }
    canvas.drawPath(clipper.getClip(size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SpeechBubble extends StatelessWidget {
  SpeechBubble({
    Key? key,
    this.elevation = 2.0,
    Color? color,
    Color? shadowColor,
    EdgeInsets? padding,
    this.margin,
    this.alignment,
    NipDirection? nipDirection,
    SpeechBubbleStyle style = const SpeechBubbleStyle(),
    required this.child,
  })  : color = style.color ?? color ?? Colors.white,
        shadowColor = style.shadowColor ?? shadowColor ?? Colors.black,
        clipper = SpeechBubbleClipper(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          radius: style.radius,
          nipDirection: nipDirection ?? NipDirection.leftCenter,
          nipWidth: style.nipWidth,
          nipHeight: style.nipHeight,
          nipOffset: style.nipOffset,
          nipRadius: style.nipRadius,
          stick: style.stick,
        ),
        super(key: key);

  final double elevation;
  final Color color;
  final Color shadowColor;
  final EdgeInsets? margin;
  final Alignment? alignment;
  final SpeechBubbleClipper clipper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: alignment,
      child: CustomPaint(
        painter: SpeechBubblePainter(
          elevation: elevation,
          color: color,
          shadowColor: Colors.black,
          clipper: clipper,
        ),
        child: Padding(padding: clipper.edgeInsets, child: child),
      ),
    );
  }
}
