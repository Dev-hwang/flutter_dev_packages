import 'package:sentry/sentry.dart';

enum LogLevel {
  /// 치명적인 오류 발생을 의미합니다.
  fatal,

  /// 일반적인 오류 발생을 의미합니다.
  error,

  /// 디버깅 로그를 의미합니다.
  debug,

  /// 경고 메시지로 오류 발생 가능성이 있음을 의미합니다.
  warning,

  /// 정보 로그를 의미합니다.
  info,
}

extension LogLevelExtension on LogLevel {
  /// [LogLevel]을 [SentryLevel]로 변환한다.
  SentryLevel toSentryLevel() {
    switch (this) {
      case LogLevel.fatal:
        return SentryLevel.fatal;
      case LogLevel.error:
        return SentryLevel.error;
      case LogLevel.debug:
        return SentryLevel.debug;
      case LogLevel.warning:
        return SentryLevel.warning;
      case LogLevel.info:
        return SentryLevel.info;
    }
  }

  /// [LogLevel]을 의미하는 이모지를 가져온다.
  String get emoji {
    switch (this) {
      case LogLevel.fatal:
        return '💣';
      case LogLevel.error:
        return '⛔';
      case LogLevel.debug:
        return '🐛';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.info:
        return '💡';
    }
  }
}
