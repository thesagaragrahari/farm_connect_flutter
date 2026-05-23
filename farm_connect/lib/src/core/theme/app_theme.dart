import 'package:flutter/material.dart';

import 'app_palette.dart';

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

  static const Color lightBackground = Color(0xFFF8F1E3);
  static const Color lightSurface = Color(0xFFFFFBF1);
  static const Color lightSurfaceAlt = Color(0xFFEAF2DE);
  static const Color lightText = Color(0xFF213A22);
  static const Color lightMutedText = Color(0xFF647050);

  static const String lightAppIconUrl =
      'https://farm-connect-backend-1.onrender.com/images/emails-app.png';
  static const String darkAppIconUrl =
      'https://farm-connect-backend-1.onrender.com/images/app_icon_dark.png';
  static const String appIconUrl = lightAppIconUrl;

  static const String lightBackgroundImageUrl =
      'https://farm-connect-backend-1.onrender.com/images/light_bg.png';
  static const String darkBackgroundImageUrl =
      'https://farm-connect-backend-1.onrender.com/images/dark_bg.png';

  static String appIconUrlFor(BuildContext context) {
    return isDark(context) ? darkAppIconUrl : lightAppIconUrl;
  }

  static String backgroundImageUrlFor(BuildContext context) {
    return isDark(context) ? darkBackgroundImageUrl : lightBackgroundImageUrl;
  }

  static ImageProvider backgroundImageFor(BuildContext context) {
    if (isDark(context)) return const NetworkImage(darkBackgroundImageUrl);
    return const NetworkImage(lightBackgroundImageUrl);
  }

  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static AppPalette palette(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ??
        AppPalette.fromBrightness(Theme.of(context).brightness);
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color appBackground(BuildContext context) {
    return palette(context).pageBackground;
  }

  static Color appSurface(BuildContext context) {
    return palette(context).card;
  }

  static Color appSurfaceAlt(BuildContext context) {
    return isDark(context) ? darkSurfaceAlt : lightSurfaceAlt;
  }

  static Color appText(BuildContext context) {
    return palette(context).primaryText;
  }

  static Color appMutedText(BuildContext context) {
    return palette(context).secondaryText;
  }

  static List<Color> appGradient(BuildContext context) {
    return palette(context).outerGradient;
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

  static BoxDecoration cardDecoration(
    BuildContext context, {
    bool featured = false,
    bool elevated = false,
  }) {
    final dark = isDark(context);
    final palette = AppTheme.palette(context);
    return BoxDecoration(
      color: appSurface(context),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: featured
            ? palette.shellGradient
            : [
                palette.card,
                dark ? const Color(0xFF102116) : const Color(0xFFF1F6E9),
              ],
      ),
      borderRadius: BorderRadius.circular(featured ? 16 : 12),
      border: Border.all(
        color: dark
            ? metallicGold.withValues(alpha: featured ? 0.22 : 0.14)
            : earthBrown.withValues(alpha: featured ? 0.30 : 0.22),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: dark ? (elevated ? 0.22 : 0.14) : (elevated ? 0.12 : 0.075),
          ),
          blurRadius: elevated ? 24 : 16,
          offset: Offset(0, elevated ? 10 : 6),
        ),
        if (!dark)
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.58),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        if (featured)
          BoxShadow(
            color: (dark ? metallicGold : forestGreen).withValues(
              alpha: dark ? 0.08 : 0.075,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
      ],
    );
  }

  static BoxDecoration subtleGlowDecoration(BuildContext context) {
    final dark = isDark(context);
    return BoxDecoration(
      shape: BoxShape.circle,
      color: (dark ? metallicGold : forestGreen).withValues(alpha: 0.12),
      boxShadow: [
        BoxShadow(
          color: (dark ? metallicGold : forestGreen).withValues(alpha: 0.12),
          blurRadius: 18,
        ),
      ],
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final palette = AppPalette.fromBrightness(brightness);
    final background = palette.pageBackground;
    final surface = palette.card;
    final text = palette.primaryText;
    final muted = palette.secondaryText;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: forestGreen,
      brightness: brightness,
      primary: forestGreen,
      secondary: isDark ? earthBrown : const Color(0xFF9D7A33),
      tertiary: metallicGold,
      surface: surface,
      surfaceContainerHighest:
          isDark ? darkSurfaceAlt : const Color(0xFFE7EEDB),
      onSurface: text,
      error: const Color(0xFFD84A3A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: [palette],
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: isDark
            ? darkBackground.withValues(alpha: 0.94)
            : lightSurface.withValues(alpha: 0.94),
        foregroundColor: isDark ? darkText : forestGreen,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: isDark ? darkText : forestGreen,
        ),
        iconTheme: IconThemeData(
          color: isDark ? darkText : forestGreen,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF3B4A2F) : const Color(0xFFD2B47C),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: text,
          fontSize: 26,
        ),
        titleLarge:
            TextStyle(color: text, fontWeight: FontWeight.w800, fontSize: 20),
        titleMedium:
            TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 16),
        bodyLarge: TextStyle(color: text, fontSize: 16, height: 1.45),
        bodyMedium: TextStyle(color: text, fontSize: 14, height: 1.45),
        bodySmall: TextStyle(color: muted, fontSize: 12, height: 1.4),
      ),
      iconTheme: IconThemeData(
        color: isDark ? darkText : forestGreen,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF0C1B11) : const Color(0xFFFFFAEF),
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),
        hintStyle: TextStyle(color: muted.withValues(alpha: 0.78)),
        prefixIconColor: isDark ? darkMutedText : forestGreen,
        suffixIconColor: isDark ? darkMutedText : forestGreen,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? metallicGold : forestGreen,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: isDark
            ? darkBackground.withValues(alpha: 0.96)
            : lightSurface.withValues(alpha: 0.96),
        indicatorColor: isDark
            ? metallicGold.withValues(alpha: 0.22)
            : forestGreen.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? text : muted,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? (isDark ? metallicGold : forestGreen)
                : muted,
            size: 22,
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        indicatorColor: isDark ? metallicGold : forestGreen,
        labelColor: text,
        unselectedLabelColor: muted,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
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
