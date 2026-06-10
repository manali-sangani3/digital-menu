import 'package:flutter/material.dart';

class CafeTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6F4E37), // Coffee Brown
        primary: const Color(0xFF6F4E37),
        secondary: const Color(0xFFD2B48C), // Latte
        surface: const Color(0xFFFAF0E6), // Cream
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.bold,
          color: Color(0xFF3E2723), // Dark Espresso
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.bold,
          color: Color(0xFF3E2723),
        ),
        titleMedium: TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
          color: Color(0xFF3E2723),
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF5D4037),
        ),
      ),
    );
  }
}
