import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0A7CFF),
        primary: const Color(0xFF0A7CFF),
        surface: Colors.white,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF202129),
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.18,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF202129),
          fontSize: 28,
          fontWeight: FontWeight.w800,
          height: 1.12,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF737780),
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.45,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF202129),
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.25,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
