import 'dart:io';
import 'dart:async';

import 'package:flutter_dev_packages/network/exception/api_exception.dart';
import 'package:sqflite/sqflite.dart';

class KnownException implements Exception {
  const KnownException([this._message]);

  final String? _message;

  @override
  String toString() => _message ?? 'KnownException';
}

class ExceptionUtils {
  ExceptionUtils._internal();
  static final instance = ExceptionUtils._internal();

  /// [exception]이 발생한 이유를 리턴한다.
  /// 정의된 조건 이외의 예외가 발생하면 [unknownIssueDesc]를 리턴한다.
  String getReason(
    dynamic exception, {
    String? unknownIssueDesc,
  }) {
    String reason = unknownIssueDesc ?? '';
    if (exception is FormatException) {
      reason = '유효하지 않은 데이터 형식입니다.';
    } else if (exception is SocketException) {
      reason = '네트워크 연결 상태가 좋지 않습니다.';
    } else if (exception is TimeoutException) {
      reason = '요청 시간이 초과되었습니다.';
    } else if (exception is DatabaseException) {
      reason = '데이터 처리 중 오류가 발생했습니다.';
    } else if (exception is ApiException) {
      reason = exception.toString();
    } else if (exception is KnownException) {
      reason = exception.toString();
    } else if (reason.isEmpty) {
      reason = '오류가 발생하여 요청을 처리할 수 없습니다.';
    }

    return reason;
  }
}
