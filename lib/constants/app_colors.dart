import 'package:flutter/material.dart';

class AppTheme {
  static const Color kColorSuccess = Color(0xFF10B981);
  static const Color kColorDanger = Color(0xFFEF4444);

  // Light Theme Configuration
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF404F68),
    scaffoldBackgroundColor: const Color(0xFFF2F2F2),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF404F68),
      secondary: Color(0xFF7A859D),
      surface: Colors.white,
    ),
  );

  // Dark Theme Configuration
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF404F68),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF404F68),
      secondary: Color(0xFF333333),
      surface: Color(0xFF1E1E1E),
    ),
  );
}
