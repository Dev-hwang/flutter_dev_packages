import 'log_level.dart';

class LogEvent {
  const LogEvent({
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
  });

  /// 로그 수준
  final LogLevel level;

  /// 로그 메시지
  final String? message;

  /// 오류
  final dynamic error;

  /// 오류 리포트
  final dynamic stackTrace;
}
