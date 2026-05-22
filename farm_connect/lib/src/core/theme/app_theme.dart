import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color.fromARGB(255, 36, 92, 39);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color backgroundWhite = Color(0xFFF9FBF9);
  static const Color earthBrown = Color.fromARGB(255, 162, 119, 45);
  static const Color forestGreen = Color.fromARGB(255, 36, 92, 39);

  static const Color metallicGold = Color(0xFFD4A84F);
  static const Color darkBackground = Color(0xFF07130B);
  static const Color darkSurface = Color(0xFF13251A);
  static const Color darkSurfaceAlt = Color(0xFF102116);
  static const Color darkBrown = Color(0xFF2A1F11);
  static const Color darkText = Color(0xFFEAF8E5);
  static const Color darkMutedText = Color(0xFFB7D6A9);

  static const Color lightBackground = Color(0xFFF4E9D6);
  static const Color lightSurface = Color(0xFFFFF1D9);
  static const Color lightSurfaceAlt = Color(0xFFF0DCB8);
  static const Color lightText = Color(0xFF2B1B0D);
  static const Color lightMutedText = Color(0xFF6E5630);

  static const String appIconUrl =
      'https://farm-connect-backend-1.onrender.com/images/emails-app.png';

  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color appBackground(BuildContext context) {
    return isDark(context) ? darkBackground : lightBackground;
  }

  static Color appSurface(BuildContext context) {
    return isDark(context) ? darkSurface : lightSurface;
  }

  static Color appSurfaceAlt(BuildContext context) {
    return isDark(context) ? darkSurfaceAlt : lightSurfaceAlt;
  }

  static Color appText(BuildContext context) {
    return isDark(context) ? darkText : lightText;
  }

  static Color appMutedText(BuildContext context) {
    return isDark(context) ? darkMutedText : lightMutedText;
  }

  static List<Color> appGradient(BuildContext context) {
    return isDark(context)
        ? const [darkBackground, darkSurfaceAlt, darkBrown]
        : const [Color(0xFFF8EEDC), lightBackground, Color(0xFFE3C996)];
  }

  static LinearGradient metallicGradient({bool light = false}) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: light
          ? const [Color(0xFFF4DBA9), earthBrown, forestGreen]
          : const [forestGreen, Color(0xFF0B3B1A), earthBrown],
    );
  }

  static BoxDecoration cardDecoration(BuildContext context) {
    final dark = isDark(context);
    return BoxDecoration(
      color: appSurface(context),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: dark
            ? metallicGold.withValues(alpha: 0.24)
            : earthBrown.withValues(alpha: 0.34),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: dark ? 0.22 : 0.10),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? darkBackground : lightBackground;
    final surface = isDark ? darkSurface : lightSurface;
    final text = isDark ? darkText : lightText;
    final muted = isDark ? darkMutedText : lightMutedText;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: forestGreen,
      brightness: brightness,
      primary: forestGreen,
      secondary: earthBrown,
      tertiary: metallicGold,
      surface: surface,
      onSurface: text,
      error: const Color(0xFFD84A3A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: isDark ? forestGreen : earthBrown,
        foregroundColor: isDark ? Colors.white : const Color(0xFF173F1D),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF173F1D),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF3B4A2F) : const Color(0xFFD2B47C),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: text,
          fontSize: 24,
        ),
        titleLarge: TextStyle(color: text, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: text, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
        bodySmall: TextStyle(color: muted),
      ),
      iconTheme: IconThemeData(
        color: isDark ? darkText : forestGreen,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF0C1B11) : const Color(0xFFFFF6E8),
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),
        hintStyle: TextStyle(color: muted.withValues(alpha: 0.78)),
        prefixIconColor: isDark ? darkMutedText : forestGreen,
        suffixIconColor: isDark ? darkMutedText : forestGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: _inputBorder(isDark, false),
        enabledBorder: _inputBorder(isDark, false),
        focusedBorder: _inputBorder(isDark, true),
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? metallicGold : forestGreen,
          foregroundColor: isDark ? const Color(0xFF102116) : Colors.white,
          disabledBackgroundColor:
              isDark ? const Color(0xFF566044) : const Color(0xFFB7C6A9),
          disabledForegroundColor: isDark ? darkMutedText : lightMutedText,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? darkText : forestGreen,
          side: BorderSide(
            color: isDark
                ? metallicGold.withValues(alpha: 0.48)
                : earthBrown.withValues(alpha: 0.58),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return metallicGold;
          return isDark ? darkMutedText : lightMutedText;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return forestGreen.withValues(alpha: 0.58);
          }
          return earthBrown.withValues(alpha: isDark ? 0.28 : 0.22);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? darkSurfaceAlt : lightSurfaceAlt,
        selectedColor: isDark
            ? metallicGold.withValues(alpha: 0.28)
            : forestGreen.withValues(alpha: 0.18),
        labelStyle: TextStyle(color: text, fontWeight: FontWeight.w700),
        side: BorderSide(
          color: isDark
              ? metallicGold.withValues(alpha: 0.32)
              : earthBrown.withValues(alpha: 0.35),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? darkSurface : lightText,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(bool isDark, bool focused) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: focused
            ? (isDark ? metallicGold : forestGreen)
            : (isDark
                ? metallicGold.withValues(alpha: 0.28)
                : earthBrown.withValues(alpha: 0.34)),
        width: focused ? 1.5 : 1,
      ),
    );
  }

  static final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Color(0xFFD84A3A), width: 1.2),
  );
}
