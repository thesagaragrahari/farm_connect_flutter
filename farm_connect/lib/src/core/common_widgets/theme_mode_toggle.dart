import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/core/theme/app_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeToggle extends ConsumerWidget {
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final palette = AppTheme.palette(context);
    final isDark = AppTheme.isDark(context);
    final compact = MediaQuery.sizeOf(context).width < 420;
    final icon = switch (mode) {
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
      ThemeMode.system => Icons.brightness_auto_rounded,
    };
    final label = switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Tooltip(
        message: 'Theme: $label',
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => ref.read(themeProvider.notifier).cycleThemeMode(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: compact ? 42 : 104,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 10),
              decoration: BoxDecoration(
                color: palette.card.withValues(alpha: isDark ? 0.62 : 0.82),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: (isDark ? AppTheme.metallicGold : AppTheme.forestGreen)
                      .withValues(alpha: isDark ? 0.24 : 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: Icon(
                      icon,
                      key: ValueKey(mode),
                      size: 19,
                      color:
                          isDark ? AppTheme.metallicGold : AppTheme.forestGreen,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 52,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          label,
                          key: ValueKey(label),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: palette.primaryText,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
