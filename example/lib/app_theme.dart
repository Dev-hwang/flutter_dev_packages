import 'package:flutter/material.dart';

class AppTheme {
  /// Material3 다크 테마 데이터를 가져옵니다.
  static ThemeData get dark => ThemeData(
    // GENERAL CONFIGURATION
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(),
    ),
    useMaterial3: true,

    // COLOR
    colorScheme: const ColorScheme.dark(),

    // TYPOGRAPHY & ICONOGRAPHY
    typography: Typography.material2021(),
  );
}