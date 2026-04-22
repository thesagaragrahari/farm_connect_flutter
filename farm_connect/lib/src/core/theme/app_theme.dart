import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color.fromARGB(255, 36, 92, 39);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color backgroundWhite = Color(0xFFF9FBF9);
  static const Color earthBrown = Color.fromARGB(255, 162, 119, 45); 
  static const Color forestGreen = Color.fromARGB(255, 36, 92, 39);

  // Light Theme Configuration
  static ThemeData get lightTheme {
    return _buildTheme(Brightness.light);
  }

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: brightness,
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: isDark ? const Color(0xFF1E1E1E) : backgroundWhite,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : backgroundWhite,
      
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold, 
          color: isDark ? secondaryGreen : primaryGreen,
          fontSize: 24,
        ),
        bodyLarge: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
