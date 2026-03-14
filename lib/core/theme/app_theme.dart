import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF05070F);
  static const Color surface = Color(0xFF0E1220);
  static const Color card = Color(0xFF171A33);
  static const Color cardBorder = Color(0xFF272B4D);

  static const Color primary = Color(0xFF39E6A0);
  static const Color accentBlue = Color(0xFF4C7DFF);

  static const Color textPrimary = Color(0xFFF5F7FF);
  static const Color textSecondary = Color(0xFFB1B7C9);
  static const Color textMuted = Color(0xFF6F7890);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      canvasColor: background,
      fontFamily: null,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accentBlue,
        surface: surface,
        error: Color(0xFFFF6B6B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
