import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  cardColor: const Color.fromARGB(255, 50, 50, 50),
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  primaryColor: AppConfig.appThemeColor,
  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade900),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: AppConfig.appThemeColor,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppConfig.appThemeColor,
      foregroundColor: Colors.white,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppConfig.appThemeColor,
    primary: AppConfig.appThemeColor,
    brightness: Brightness.dark,
  ),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  primaryColor: AppConfig.appThemeColor,
  dividerTheme: DividerThemeData(color: Colors.grey.shade300),
  appBarTheme: AppBarTheme(
    backgroundColor: AppConfig.appThemeColor,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppConfig.appThemeColor,
      foregroundColor: Colors.white,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppConfig.appThemeColor,
    primary: AppConfig.appThemeColor,
    brightness: Brightness.light,
  ),
);
