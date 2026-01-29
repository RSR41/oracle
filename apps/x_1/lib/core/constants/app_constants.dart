import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'EF';
  static const String appPackageName = 'com.rsr41.ef';
  static const String databaseName = 'ef_app.db';

  static const List<Locale> supportedLocales = [
    Locale('ko', 'KR'),
    Locale('en', 'US'),
  ];

  static const Locale defaultLocale = Locale('ko', 'KR');
}
