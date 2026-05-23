import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final dark = AppTheme.isDark(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.pageBackground,
        image: DecorationImage(
          image: AppTheme.backgroundImageFor(context),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          opacity: dark ? 0.92 : 0.19,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.outerGradient.first.withValues(alpha: dark ? 0.90 : 0.70),
              palette.outerGradient[1].withValues(alpha: dark ? 0.78 : 0.54),
              palette.outerGradient.last.withValues(alpha: dark ? 0.88 : 0.62),
            ],
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.72, -0.78),
              radius: 1.18,
              colors: [
                (dark ? AppTheme.metallicGold : Colors.white)
                    .withValues(alpha: dark ? 0.10 : 0.28),
                Colors.transparent,
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
