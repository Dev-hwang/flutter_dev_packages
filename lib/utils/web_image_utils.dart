import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class WebImageUtils {
  WebImageUtils._internal();
  static final instance = WebImageUtils._internal();

  /// [url]에서 이미지를 가져온다.
  Image getImageFromUrl({
    required String url,
    double? width,
    double? height,
    BoxFit? boxFit = BoxFit.fill,
  }) =>
      Image.network(url, width: width, height: height, fit: boxFit);

  /// 외부 저장소에서 [fileName] 이미지를 가져온다.
  Future<Image> getImageFromExternalStorage({
    required String fileName,
    double? width,
    double? height,
    BoxFit? boxFit = BoxFit.fill,
  }) async {
    final directory = await getExternalStorageDirectory();
    final imageFile = File('${directory?.absolute.path}/$fileName');

    return Image.file(imageFile, width: width, height: height, fit: boxFit);
  }

  /// [url]에서 가져온 이미지를 외부 저장소에 저장한다.
  Future<bool> saveImageToExternalStorage({
    required String url,
    required String fileName,
    double? width,
    double? height,
    BoxFit? boxFit = BoxFit.fill,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final response = await get(Uri.parse(url)).timeout(timeout);
    if (response.statusCode == 200) {
      final directory = await getExternalStorageDirectory();
      final imageFile = File('${directory?.absolute.path}/$fileName');
      imageFile.writeAsBytesSync(response.bodyBytes);
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  /// 외부 저장소에 [fileName] 이미지가 있는지 확인한다.
  Future<bool> isExistsImageFile({required String fileName}) async {
    final directory = await getExternalStorageDirectory();
    final imageFile = File('${directory?.absolute.path}/$fileName');

    return await imageFile.exists();
  }
}
