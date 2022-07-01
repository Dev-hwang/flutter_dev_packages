enum HTTPMediaType {
  applicationJavascript,
  applicationJson,
  applicationXml,
  applicationZip,
  applicationPdf,
  applicationSql,
  applicationGraphql,
  applicationMsWord,
  applicationMsExcel,
  applicationMsPowerpoint,
  multipartFormData,
  textCss,
  textHtml,
  textCsv,
  textPlain,
  imagePng,
  imageJpeg,
  imageGif,
}

extension HTTPMediaTypeExtension on HTTPMediaType {
  /// HTTP 헤더에 삽입 가능한 값을 가져온다.
  String get headerValue {
    switch (this) {
      case HTTPMediaType.applicationJavascript:
        return 'application/javascript';
      case HTTPMediaType.applicationJson:
        return 'application/json';
      case HTTPMediaType.applicationXml:
        return 'application/xml';
      case HTTPMediaType.applicationZip:
        return 'application/zip';
      case HTTPMediaType.applicationPdf:
        return 'application/pdf';
      case HTTPMediaType.applicationSql:
        return 'application/sql';
      case HTTPMediaType.applicationGraphql:
        return 'application/graphql';
      case HTTPMediaType.applicationMsWord:
        return 'application/msword';
      case HTTPMediaType.applicationMsExcel:
        return 'application/vnd.ms-excel';
      case HTTPMediaType.applicationMsPowerpoint:
        return 'application/vnd.ms-powerpoint';
      case HTTPMediaType.multipartFormData:
        return 'multipart/form-data';
      case HTTPMediaType.textCss:
        return 'text/css';
      case HTTPMediaType.textHtml:
        return 'text/html';
      case HTTPMediaType.textCsv:
        return 'text/csv';
      case HTTPMediaType.textPlain:
        return 'text/plain';
      case HTTPMediaType.imagePng:
        return 'image/png';
      case HTTPMediaType.imageJpeg:
        return 'image/jpeg';
      case HTTPMediaType.imageGif:
        return 'image/gif';
    }
  }
}
