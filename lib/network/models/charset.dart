enum Charset {
  eucKr,
  utf_8,
}

extension CharsetExtension on Charset {
  /// HTTP 헤더에 삽입 가능한 값을 가져온다.
  String get headerValue {
    switch (this) {
      case Charset.eucKr:
        return 'euc-kr';
      case Charset.utf_8:
        return 'utf-8';
    }
  }
}
