import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _settingsBoxName = 'app_settings';
const _themeModeKey = 'theme_mode';

final themeProvider = NotifierProvider<AppThemeController, ThemeMode>(
  AppThemeController.new,
);

class AppThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final savedValue = _settingsBox.get(_themeModeKey);
    return _themeModeFromString(savedValue);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _settingsBox.put(_themeModeKey, mode.name);
  }

  Future<void> cycleThemeMode() {
    final nextMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    return setThemeMode(nextMode);
  }

  Box<String> get _settingsBox => Hive.box<String>(_settingsBoxName);

  ThemeMode _themeModeFromString(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
