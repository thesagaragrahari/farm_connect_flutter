import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'src/core/storage/hive_init.dart';
import 'src/routing/router.dart';

// Global provider to manage Theme state
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();   // 🔥 ADD THIS

  // Capture Flutter errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Capture async errors (VERY IMPORTANT)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await initHive();  // your existing code

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    // Common Branding Colors
    const primaryGreen = Color(0xFF4CAF50);

    return MaterialApp.router(
      routerConfig: router,
      title: 'KrishiSetu',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,

      // --- LIGHT THEME ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: primaryGreen,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        inputDecorationTheme: _buildInputTheme(isDark: false),
        elevatedButtonTheme: _buildButtonTheme(isDark: false),
      ),

      // --- DARK THEME (Matching your email screenshot) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          brightness: Brightness.dark,
          surface: const Color(0xFF161B22), // The card color from your image
        ),
        inputDecorationTheme: _buildInputTheme(isDark: true),
        elevatedButtonTheme: _buildButtonTheme(isDark: true),
      ),
    );
  }

  // Global Input Style (Production Tip: Define this once to use everywhere)
  InputDecorationTheme _buildInputTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF0D1117) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
      ),
    );
  }

  ElevatedButtonThemeData _buildButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: isDark ? Colors.black : Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}