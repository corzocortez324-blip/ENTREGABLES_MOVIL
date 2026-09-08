import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006B5F),
        secondary: const Color(0xFF5D6470),
        tertiary: const Color(0xFFB85C38),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8F6),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF22B8A5),
        secondary: const Color(0xFFB7C0CA),
        tertiary: const Color(0xFFE09B73),
        brightness: Brightness.dark,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
