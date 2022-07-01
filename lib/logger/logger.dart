import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter_dev_packages/logger/models/log_event.dart';
import 'package:flutter_dev_packages/logger/models/log_level.dart';
import 'package:flutter_dev_packages/logger/printer.dart';
import 'package:sentry/sentry.dart';

export 'package:sentry/sentry.dart';

class Logger {
  static final _printer = Printer();

  static SentryEvent _printLog(LogEvent event, {bool onlyShowMessage = false}) {
    final contents = _printer.print(event, onlyShowMessage: onlyShowMessage);
    String message = '';
    for (final content in contents) {
      message += content;
      if (!onlyShowMessage) message += '\n';
    }

    if (!kReleaseMode) dev.log(message);

    return SentryEvent(
      level: event.level.toSentryLevel(),
      throwable: event.error,
      message: SentryMessage(message),
    );
  }

  /// [LogLevel.fatal] 수준의 로그를 출력하고 Sentry 서버로 전송한다.
  static Future<SentryId?> f(
    String? message, {
    dynamic error,
    dynamic stackTrace,
    bool captureEvent = true,
    bool onlyShowMessage = false,
  }) async {
    final logEvent = LogEvent(
      level: LogLevel.fatal,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    final sentryEvent = _printLog(logEvent, onlyShowMessage: onlyShowMessage);
    if (captureEvent) {
      return await Sentry.captureEvent(sentryEvent, stackTrace: stackTrace);
    }

    return null;
  }

  /// [LogLevel.error] 수준의 로그를 출력하고 Sentry 서버로 전송한다.
  static Future<SentryId?> e(
    String? message, {
    dynamic error,
    dynamic stackTrace,
    bool captureEvent = true,
    bool onlyShowMessage = false,
  }) async {
    final logEvent = LogEvent(
      level: LogLevel.error,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    final sentryEvent = _printLog(logEvent, onlyShowMessage: onlyShowMessage);
    if (captureEvent) {
      return await Sentry.captureEvent(sentryEvent, stackTrace: stackTrace);
    }

    return null;
  }

  /// [LogLevel.debug] 수준의 로그를 출력하고 Sentry 서버로 전송한다.
  static Future<SentryId?> d(
    String? message, {
    dynamic error,
    dynamic stackTrace,
    bool captureEvent = false,
    bool onlyShowMessage = true,
  }) async {
    final logEvent = LogEvent(
      level: LogLevel.debug,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    final sentryEvent = _printLog(logEvent, onlyShowMessage: onlyShowMessage);
    if (captureEvent) {
      return await Sentry.captureEvent(sentryEvent, stackTrace: stackTrace);
    }

    return null;
  }

  /// [LogLevel.warning] 수준의 로그를 출력하고 Sentry 서버로 전송한다.
  static Future<SentryId?> w(
    String? message, {
    dynamic error,
    dynamic stackTrace,
    bool captureEvent = false,
    bool onlyShowMessage = true,
  }) async {
    final logEvent = LogEvent(
      level: LogLevel.warning,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    final sentryEvent = _printLog(logEvent, onlyShowMessage: onlyShowMessage);
    if (captureEvent) {
      return await Sentry.captureEvent(sentryEvent, stackTrace: stackTrace);
    }

    return null;
  }

  /// [LogLevel.info] 수준의 로그를 출력하고 Sentry 서버로 전송한다.
  static Future<SentryId?> i(
    String? message, {
    dynamic error,
    dynamic stackTrace,
    bool captureEvent = false,
    bool onlyShowMessage = true,
  }) async {
    final logEvent = LogEvent(
      level: LogLevel.info,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    final sentryEvent = _printLog(logEvent, onlyShowMessage: onlyShowMessage);
    if (captureEvent) {
      return await Sentry.captureEvent(sentryEvent, stackTrace: stackTrace);
    }

    return null;
  }
}
