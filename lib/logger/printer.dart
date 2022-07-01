import 'dart:convert';

import 'package:flutter_dev_packages/logger/models/log_event.dart';
import 'package:flutter_dev_packages/logger/models/log_level.dart';

const String _topLeftCorner = '┌';
const String _bottomLeftCorner = '└';
const String _middleCorner = '├';
const String _verticalLine = '│';
const String _doubleDivider = '─';
const String _singleDivider = '┄';

class Printer {
  final _deviceStackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
  final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');
  final _browserStackTraceRegex = RegExp(r'^(?:package:)?(dart:[^\s]+|[^\s]+)');

  Printer({
    this.stackTraceBeginIndex = 0,
    this.methodCount = 10,
    this.errorMethodCount = 10,
    this.lineLength = 100,
  }) {
    final doubleDividerLine = StringBuffer();
    final singleDividerLine = StringBuffer();
    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(_doubleDivider);
      singleDividerLine.write(_singleDivider);
    }

    _topBorder = '$_topLeftCorner$doubleDividerLine';
    _middleBorder = '$_middleCorner$singleDividerLine';
    _bottomBorder = '$_bottomLeftCorner$doubleDividerLine';
  }

  final int stackTraceBeginIndex;
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  /// [event]를 인쇄한다.
  List<String> print(LogEvent event, {bool onlyShowMessage = false}) {
    final emoji = event.level.emoji;
    final message = _stringifyMessage(event.message);

    final buffer = <String>[];
    buffer.add('$emoji $message');

    if (!onlyShowMessage) {
      buffer.add(_topBorder);

      final error = event.error?.toString();
      if (error != null) {
        for (final line in error.split('\n')) {
          buffer.add('$_verticalLine $line');
        }
        buffer.add(_middleBorder);
      }

      String? stackTrace;
      if (event.stackTrace == null) {
        if (methodCount > 0) {
          stackTrace = _formatStackTrace(StackTrace.current, methodCount);
        }
      } else if (errorMethodCount > 0) {
        stackTrace = _formatStackTrace(event.stackTrace, errorMethodCount);
      }

      if (stackTrace != null) {
        for (final line in stackTrace.split('\n')) {
          buffer.add('$_verticalLine $line');
        }
        buffer.add(_middleBorder);
      }

      final timestamp = DateTime.now().toString();
      buffer.add('$_verticalLine $timestamp');

      buffer.add(_bottomBorder);
    }

    return buffer;
  }

  bool _discardDeviceStackTraceLine(String line) {
    final match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) return false;

    return match.group(2)!.startsWith('package:logger');
  }

  bool _discardWebStackTraceLine(String line) {
    final match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) return false;

    return match.group(1)!.startsWith('packages/logger') ||
        match.group(1)!.startsWith('dart-sdk/lib');
  }

  bool _discardBrowserStackTraceLine(String line) {
    final match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) return false;

    return match.group(1)!.startsWith('package:logger') ||
        match.group(1)!.startsWith('dart:');
  }

  String? _stringifyMessage(dynamic message) {
    if (message == null) return null;

    if (message is Map || message is Iterable) {
      final encoder = JsonEncoder.withIndent('  ', (obj) => obj.toString());
      return encoder.convert(message);
    }

    return message.toString();
  }

  String? _formatStackTrace(StackTrace? stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');
    if (stackTraceBeginIndex > 0 && stackTraceBeginIndex < lines.length - 1) {
      lines = lines.sublist(stackTraceBeginIndex);
    }

    var formatted = <String>[];
    var count = 0;
    for (final line in lines) {
      if (line.isEmpty ||
          _discardDeviceStackTraceLine(line) ||
          _discardWebStackTraceLine(line) ||
          _discardBrowserStackTraceLine(line)) {
        continue;
      }

      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');

      if (++count == methodCount) break;
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }
}
