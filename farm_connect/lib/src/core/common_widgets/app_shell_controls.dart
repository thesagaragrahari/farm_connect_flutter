import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/core/theme/app_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShellControls extends ConsumerWidget {
  const AppShellControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final desktopMode = ref.watch(desktopModeProvider);
    final lightMode = ref.watch(themeProvider) == ThemeMode.light;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppShellSwitch(
          value: desktopMode,
          enabledIcon: Icons.desktop_windows_rounded,
          disabledIcon: Icons.phone_iphone_rounded,
          enabledTooltip: 'Desktop mode',
          disabledTooltip: 'Mobile mode',
          iconColor: AppTheme.forestGreen,
          onChanged: (value) =>
              ref.read(desktopModeProvider.notifier).state = value,
        ),
        const SizedBox(width: 8),
        AppShellSwitch(
          value: lightMode,
          enabledIcon: Icons.light_mode_rounded,
          disabledIcon: Icons.dark_mode_rounded,
          enabledTooltip: 'Light mode',
          disabledTooltip: 'Dark mode',
          iconColor: AppTheme.earthBrown,
          onChanged: (value) => ref.read(themeProvider.notifier).state =
              value ? ThemeMode.light : ThemeMode.dark,
        ),
      ],
    );
  }
}

class AppShellSwitch extends StatelessWidget {
  final bool value;
  final IconData enabledIcon;
  final IconData disabledIcon;
  final String enabledTooltip;
  final String disabledTooltip;
  final Color iconColor;
  final ValueChanged<bool> onChanged;

  const AppShellSwitch({
    super.key,
    required this.value,
    required this.enabledIcon,
    required this.disabledIcon,
    required this.enabledTooltip,
    required this.disabledTooltip,
    required this.iconColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: value ? enabledTooltip : disabledTooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 58,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.black.withValues(alpha: 0.24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.36)),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                value ? enabledIcon : disabledIcon,
                size: 15,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
