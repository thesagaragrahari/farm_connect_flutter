import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/common_widgets/theme_mode_toggle.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/theme/app_palette.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/auth_background.dart';
import 'package:flutter/material.dart';

class AuthShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);

    return Scaffold(
      backgroundColor: palette.pageBackground,
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final breakpoint =
                  ResponsiveLayout.breakpointFor(constraints.maxWidth);
              final desktop = breakpoint == AppBreakpoint.desktop;
              final padding = ResponsiveLayout.pagePadding(context);

              final content = Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: desktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _AuthHeroPanel(
                                title: title,
                                subtitle: subtitle,
                                palette: palette,
                              ),
                            ),
                            SizedBox(width: padding),
                            Flexible(
                              child: _AuthFormCard(
                                footerActions: footerActions,
                                child: child,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _AuthHeroPanel(
                              title: title,
                              subtitle: subtitle,
                              palette: palette,
                              compact: breakpoint == AppBreakpoint.mobile,
                            ),
                            SizedBox(height: padding),
                            _AuthFormCard(
                              footerActions: footerActions,
                              child: child,
                            ),
                          ],
                        ),
                ),
              );

              return Stack(
                children: [
                  SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          padding + 52,
                          padding,
                          padding,
                        ),
                        child: content,
                      ),
                    ),
                  ),
                  const PositionedDirectional(
                    top: AppSpacing.sm,
                    start: AppSpacing.sm,
                    end: AppSpacing.sm,
                    child: _AuthFloatingBar(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AuthFloatingBar extends StatelessWidget {
  const _AuthFloatingBar();

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final dark = AppTheme.isDark(context);

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: palette.card.withValues(alpha: dark ? 0.58 : 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                  .withValues(alpha: dark ? 0.20 : 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.16 : 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PremiumBrandIcon(size: 32),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'FarmConnect',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: palette.primaryText,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const ThemeModeToggle(),
      ],
    );
  }
}

class _AuthHeroPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppPalette palette;
  final bool compact;

  const _AuthHeroPanel({
    required this.title,
    required this.subtitle,
    required this.palette,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final markSize = compact ? 68.0 : 88.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        );
      },
      child: AppSurface(
        padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AuthBrandMark(size: markSize),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: palette.primaryText,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: textTheme.bodyLarge?.copyWith(
                color: palette.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthFormCard extends StatelessWidget {
  final Widget child;
  final List<Widget>? footerActions;

  const _AuthFormCard({
    required this.child,
    this.footerActions,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AppSurface(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            if (footerActions != null && footerActions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              ...footerActions!,
            ],
          ],
        ),
      ),
    );
  }
}

class _AuthBrandMark extends StatelessWidget {
  final double size;

  const _AuthBrandMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
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
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(size > 72 ? 4 : 3),
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
        ),
      ),
    );
  }
}
