import 'package:farm_connect/src/core/common_widgets/app_shell_controls.dart';
import 'package:farm_connect/src/core/theme/app_palette.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/core/theme/app_theme_controller.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthShell extends ConsumerWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget>? footerActions;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footerActions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppTheme.palette(context);
    final desktopMode = ref.watch(desktopModeProvider);

    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              width: desktopMode ? double.infinity : 430,
              height: desktopMode ? double.infinity : 860,
              constraints: BoxConstraints(
                maxWidth: desktopMode ? 1180 : 430,
                maxHeight: desktopMode ? double.infinity : 860,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: desktopMode ? 24 : 14,
                vertical: desktopMode ? 18 : 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(desktopMode ? 16 : 34),
                border: Border.all(
                  color: AppTheme.metallicGold.withValues(alpha: 0.48),
                  width: desktopMode ? 1 : 2,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: palette.shellGradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: AppTheme.forestGreen.withValues(alpha: 0.20),
                    blurRadius: 42,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: _AuthFrame(
                title: title,
                subtitle: subtitle,
                palette: palette,
                desktopMode: desktopMode,
                footerActions: footerActions,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthFrame extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppPalette palette;
  final bool desktopMode;
  final Widget child;
  final List<Widget>? footerActions;

  const _AuthFrame({
    required this.title,
    required this.subtitle,
    required this.palette,
    required this.desktopMode,
    required this.child,
    this.footerActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AuthTopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 18),
                    child: child,
                  ),
                );
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: desktopMode ? 520 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AuthHero(
                        title: title,
                        subtitle: subtitle,
                        palette: palette,
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: palette.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                AppTheme.metallicGold.withValues(alpha: 0.34),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: palette.lightMode ? 0.10 : 0.24,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            child,
                            if (footerActions != null &&
                                footerActions!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ...footerActions!,
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthTopBar extends StatelessWidget {
  const _AuthTopBar();

  @override
  Widget build(BuildContext context) {
    final lightMode = !AppTheme.isDark(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: lightMode
              ? [
                  const Color(0xFF8B6429),
                  AppTheme.earthBrown,
                  const Color(0xFFD8B46F),
                ]
              : [
                  AppTheme.forestGreen,
                  const Color(0xFF0B3B1A),
                  AppTheme.earthBrown.withValues(alpha: 0.88),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const _AuthBrandMark(size: 46),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FarmConnect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Secure access',
                  style: TextStyle(
                    color: Color(0xFFE7F4DF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_rounded,
            color: lightMode ? const Color(0xFF173F1D) : Colors.white,
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.more_vert_rounded,
            color: lightMode ? const Color(0xFF173F1D) : Colors.white,
          ),
          const SizedBox(width: 8),
          const AppShellControls(),
        ],
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppPalette palette;

  const _AuthHero({
    required this.title,
    required this.subtitle,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'farm-connect-brand-logo',
          child: const _AuthBrandMark(size: 88),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.primaryText,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.secondaryText,
            height: 1.45,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AuthBrandMark extends StatelessWidget {
  final double size;

  const _AuthBrandMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size > 60 ? 4 : 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF6D0),
            Color(0xFFB8842D),
            Color(0xFFFFFFFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: size > 60 ? 18 : 10,
            offset: Offset(0, size > 60 ? 8 : 5),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          AppTheme.appIconUrlFor(context),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/farm_connect_app_icon.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
