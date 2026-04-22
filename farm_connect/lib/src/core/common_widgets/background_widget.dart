import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A Solid/Gradient Brown background used for earthy sections
class EarthBackground extends StatelessWidget {
  final Widget child;
  const EarthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.earthBrown,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.earthBrown, Color(0xFF8D6E63)],
        ),
      ),
      child: child,
    );
  }
}

/// A Deep Forest Green background for high-contrast branding
class ForestBackground extends StatelessWidget {
  final Widget child;
  const ForestBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.forestGreen,
      ),
      child: child,
    );
  }
}

/// A Placeholder for Dark Mode background (Business requirement pending)
class AdaptiveBackground extends StatelessWidget {
  final Widget child;
  const AdaptiveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDarkMode ? const Color(0xFF121212) : Colors.white,
      child: child,
    );
  }
}