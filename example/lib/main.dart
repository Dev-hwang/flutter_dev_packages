import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/flutter_dev_packages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_constant.dart';
import 'app_theme.dart';
import 'src/splash_page.dart';

void main() {
  runZonedGuarded(() async {
    await Sentry.init((options) {
      options.dsn = kSentryDsn;
    });

    runApp(const ExampleApp());
  }, (error, stackTrace) async {
    await Logger.f('FATAL EXCEPTION', error: error, stackTrace: stackTrace);
  });
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WithThemeManager(
      themeData: AppTheme.dark,
      builder: (context, themeData) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ko'),
          ],
          home: const SplashPage(),
        );
      },
    );
  }
}
