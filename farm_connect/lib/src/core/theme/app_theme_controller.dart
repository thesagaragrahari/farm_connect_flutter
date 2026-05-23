import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
final desktopModeProvider = StateProvider<bool>((ref) => false);
