import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/app_theme_controller.dart';
import 'src/core/storage/hive_init.dart';
import 'src/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final firebaseReady = await _initializeFirebaseSafely();

  if (firebaseReady && _supportsCrashlytics) {
    // Capture Flutter errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Capture async errors (VERY IMPORTANT)
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await initHive(); // your existing code

  runApp(const ProviderScope(child: MyApp()));
}

Future<bool> _initializeFirebaseSafely() async {
  if (kIsWeb) {
    debugPrint(
      'Firebase initialization skipped: web requires FlutterFire options.',
    );
    return false;
  }

  try {
    await Firebase.initializeApp();
    return true;
  } catch (e) {
    debugPrint('Firebase initialization skipped: $e');
    return false;
  }
}

bool get _supportsCrashlytics {
  if (kIsWeb) return false;

  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS =>
      true,
    TargetPlatform.fuchsia ||
    TargetPlatform.linux ||
    TargetPlatform.windows =>
      false,
  };
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'KrishiSetu',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeAnimationDuration: const Duration(milliseconds: 260),
      themeAnimationCurve: Curves.easeOutCubic,
    );
  }
}
