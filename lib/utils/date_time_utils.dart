import 'package:intl/intl.dart';

const String kDatePattern = "yyyy-MM-dd";
const String kTimePattern = "HH:mm:ss";
const String kDateTimePattern = "$kDatePattern $kTimePattern";

class DateTimeUtils {
  DateTimeUtils._internal();
  static final instance = DateTimeUtils._internal();

  /// 현재 날짜를 문자열 타입으로 반환한다.
  String getNowDateString() =>
      dateTimeToString(DateTime.now(), pattern: kDatePattern);

  /// 현재 시간을 문자열 타입으로 반환한다.
  String getNowTimeString() =>
      dateTimeToString(DateTime.now(), pattern: kTimePattern);

  /// 현재 날짜와 시간을 문자열 타입으로 반환한다.
  String getNowDateTimeString() =>
      dateTimeToString(DateTime.now(), pattern: kDateTimePattern);

  /// [value]를 [pattern] 형태의 DateTime 객체로 변환한다.
  DateTime stringToDateTime(String value, {String pattern = kDateTimePattern}) {
    return DateFormat(pattern).parse(value);
  }

  /// [value]를 [pattern] 형태의 문자열로 변환한다.
  String dateTimeToString(DateTime value, {String pattern = kDateTimePattern}) {
    return DateFormat(pattern).format(value);
  }

  /// [weekDay]에 해당하는 요일을 반환한다.
  String getWeekDayString(int weekDay) {
    switch (weekDay) {
      case 1: return '월요일';
      case 2: return '화요일';
      case 3: return '수요일';
      case 4: return '목요일';
      case 5: return '금요일';
      case 6: return '토요일';
      default: return '일요일';
    }
  }

  /// [value]의 요일을 반환한다.
  String getWeekDayByString(String value) {
    final dateTime = stringToDateTime(value, pattern: kDatePattern);
    return getWeekDayString(dateTime.weekday);
  }

  /// [value]의 요일을 반환한다.
  String getWeekDayByDateTime(DateTime value) {
    return getWeekDayString(value.weekday);
  }

  /// [dateTime]이 오늘인가?
  bool isToady(DateTime dateTime) {
    final today = DateTime.now();
    final cDate = DateTime(today.year, today.month, today.day);

    return cDate.difference(dateTime).inDays == 0;
  }

  /// [dateTime]이 이번 주인가?
  bool isWeek(DateTime dateTime) {
    final today = DateTime.now();
    final cDate = DateTime(today.year, today.month, today.day);
    final sDate = cDate.subtract(Duration(days: cDate.weekday - 1));
    final eDate = sDate.add(const Duration(days: 6));

    final diffSDate = (sDate.difference(dateTime).inDays).abs();
    final diffEDate = (eDate.difference(dateTime).inDays).abs();

    return (diffSDate + diffEDate) < 7;
  }

  /// [dateTime]이 이번 달인가?
  bool isMonth(DateTime dateTime) {
    return DateTime.now().month == dateTime.month;
  }

  /// [minValue]를 시분 텍스트로 변환한다.
  String getHourMinTextByMinValue(int minValue) {
    final hour = minValue ~/ 60;
    final min = minValue % 60;

    if (hour < 1) {
      return '$min분';
    } else {
      return '$hour시간 $min분';
    }
  }

  /// [secValue]를 분초 텍스트로 변환한다.
  String getMinSecTextBySecValue(int secValue) {
    final min = secValue % 3600 ~/ 60;
    final sec = secValue % 3600 % 60;

    if (min < 1) {
      return '$sec초';
    } else {
      return '$min분 $sec초';
    }
  }
}
