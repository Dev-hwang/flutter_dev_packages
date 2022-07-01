import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dev_packages/logger/logger.dart';
import 'package:http/http.dart';

import 'exception/api_exception.dart';
import 'models/charset.dart';
import 'models/http_media_type.dart';
import 'models/http_request_method.dart';
import 'models/network_protocol.dart';

export 'package:http/http.dart';

abstract class RestAPI {
  NetworkProtocol? _networkProtocol;
  NetworkProtocol? get networkProtocol => _networkProtocol;

  String? _authority;
  String? get authority => _authority;

  Map<String, String>? _headers;
  Map<String, String>? get headers => _headers;

  Duration? _defaultTimeout;
  Duration? get defaultTimeout => _defaultTimeout;

  /// [RestAPI]를 초기화한다.
  void initialize({
    required String authority,
    Map<String, String>? headers,
    HTTPMediaType accept = HTTPMediaType.applicationJson,
    HTTPMediaType contentType = HTTPMediaType.applicationJson,
    Charset charset = Charset.utf_8,
    Duration defaultTimeout = const Duration(seconds: 15),
  }) {
    final splitAuthority = authority.split('://');
    if (splitAuthority.length == 2) {
      final protocol = splitAuthority.first.toLowerCase();
      if (protocol == 'http') {
        _networkProtocol = NetworkProtocol.http;
      } else if (protocol == 'https') {
        _networkProtocol = NetworkProtocol.https;
      } else {
        throw const ApiException('정의되지 않은 네트워크 프로토콜입니다.');
      }
    } else if (splitAuthority.length == 1) {
      _networkProtocol = NetworkProtocol.https;
    } else {
      throw const ApiException('주소가 올바르지 않습니다.');
    }

    _authority = splitAuthority.last;

    final strAccept = accept.headerValue;
    final strContentType = contentType.headerValue;
    final strCharset = charset.headerValue;
    _headers = {
      'Accept': strAccept,
      'Content-Type': '$strContentType; charset=$strCharset',
    }..addAll(headers ?? {});

    _defaultTimeout = defaultTimeout;
  }

  /// REST 요청한다.
  Future<Map<String, dynamic>> rest({
    required HTTPRequestMethod reqMethod,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
    String resultMessageRef = 'resultMessage',
  }) async {
    if (_authority == null) {
      throw const ApiException('RestAPI가 초기화되지 않았습니다.');
    }

    final Uri completedUri = _networkProtocol == NetworkProtocol.http
        ? Uri.http(_authority!, path, queryParameters)
        : Uri.https(_authority!, path, queryParameters);

    final Map<String, String> completedHeaders = {}
      ..addAll(_headers!)
      ..addAll(headers ?? {});

    final response = await request(
      method: reqMethod,
      uri: completedUri,
      headers: completedHeaders,
      body: body,
      timeout: timeout ?? _defaultTimeout!,
    );

    final statusCode = response.statusCode;
    final decodedBody = getDecodedBody(response);
    final resultMessage = decodedBody[resultMessageRef];

    if (!kReleaseMode) {
      final sb = StringBuffer();
      sb.write('\n');
      sb.write('======== [REST RESULT] ========\n');
      sb.write('method:   $reqMethod\n');
      sb.write('uri:      $completedUri\n');
      sb.write('headers:  $completedHeaders\n');
      sb.write('query:    $queryParameters\n');
      sb.write('body:     $body\n');
      sb.write('result($statusCode): $decodedBody\n');
      sb.write('===============================\n');
      Logger.i(sb.toString());
    }

    switch (statusCode) {
      case 200: // OK
        return decodedBody;
      case 400: // Bad Request
        throw ApiException(resultMessage ?? '잘못된 요청입니다.');
      case 401: // Unauthorized
        throw ApiException(resultMessage ?? '클라이언트 인증에 실패하여 요청이 거부되었습니다.');
      case 403: // Forbidden
        throw ApiException(resultMessage ?? '접근 권한이 없어 요청이 거부되었습니다.');
      case 404: // Not Found
        throw ApiException(resultMessage ?? '요청 리소스 또는 주소를 찾을 수 없습니다.');
      default:  // Internal Server Error
        throw ApiException(resultMessage ?? '서버 오류가 발생하여 요청을 처리할 수 없습니다. (code: $statusCode)');
    }
  }

  /// HTTP 요청한다.
  Future<Response> request({
    required HTTPRequestMethod method,
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    required Duration timeout,
  }) async {
    Object? jsonBody;
    if (body != null) {
      jsonBody = jsonEncode(body);
    }

    switch (method) {
      case HTTPRequestMethod.get:
        return get(uri, headers: headers).timeout(timeout);
      case HTTPRequestMethod.put:
        return put(uri, headers: headers, body: jsonBody).timeout(timeout);
      case HTTPRequestMethod.post:
        return post(uri, headers: headers, body: jsonBody).timeout(timeout);
      case HTTPRequestMethod.delete:
        return delete(uri, headers: headers, body: jsonBody).timeout(timeout);
    }
  }

  /// 디코딩된 [response.bodyBytes]를 가져온다.
  Map<String, dynamic> getDecodedBody(Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (error) {
      return {
        'error': error.toString(),
        'errorBody': response.body,
      };
    }
  }
}
