import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppBreakpoint { mobile, tablet, desktop }

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

class ResponsiveLayout {
  static AppBreakpoint breakpointFor(double width) {
    if (width >= 1024) return AppBreakpoint.desktop;
    if (width >= 600) return AppBreakpoint.tablet;
    return AppBreakpoint.mobile;
  }

  static AppBreakpoint of(BuildContext context) {
    return breakpointFor(MediaQuery.sizeOf(context).width);
  }

  static bool isMobile(BuildContext context) {
    return of(context) == AppBreakpoint.mobile;
  }

  static bool isTablet(BuildContext context) {
    return of(context) == AppBreakpoint.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return of(context) == AppBreakpoint.desktop;
  }

  static double pagePadding(BuildContext context) {
    return switch (of(context)) {
      AppBreakpoint.mobile => AppSpacing.lg,
      AppBreakpoint.tablet => AppSpacing.xxl,
      AppBreakpoint.desktop => AppSpacing.xxxl,
    };
  }

  static double contentMaxWidth(BuildContext context) {
    return switch (of(context)) {
      AppBreakpoint.mobile => double.infinity,
      AppBreakpoint.tablet => 860,
      AppBreakpoint.desktop => 1240,
    };
  }

  static double dashboardMaxWidth(BuildContext context) {
    return switch (of(context)) {
      AppBreakpoint.mobile => double.infinity,
      AppBreakpoint.tablet => 900,
      AppBreakpoint.desktop => 1320,
    };
  }

  static double formMaxWidth(BuildContext context) {
    return switch (of(context)) {
      AppBreakpoint.mobile => double.infinity,
      AppBreakpoint.tablet => 640,
      AppBreakpoint.desktop => 720,
    };
  }

  static int gridColumns(BuildContext context, {int desktop = 3}) {
    return switch (of(context)) {
      AppBreakpoint.mobile => 1,
      AppBreakpoint.tablet => 2,
      AppBreakpoint.desktop => desktop,
    };
  }

  static double typeScale(BuildContext context) {
    return switch (of(context)) {
      AppBreakpoint.mobile => 1,
      AppBreakpoint.tablet => 1.06,
      AppBreakpoint.desktop => 1.1,
    };
  }

  static double iconSize(BuildContext context) {
    return switch (of(context)) {
      AppBreakpoint.mobile => 22,
      AppBreakpoint.tablet => 24,
      AppBreakpoint.desktop => 26,
    };
  }
}

class AppScreen extends StatelessWidget {
  final Widget child;

  const AppScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final dark = AppTheme.isDark(context);
    final textureOpacity = dark ? 0.10 : 0.066;

    return SizedBox.expand(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: palette.pageBackground,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.outerGradient,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Image(
                  image: AppTheme.backgroundImageFor(context),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  opacity: AlwaysStoppedAnimation(textureOpacity),
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _OrganicTexturePainter(
                      color:
                          (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                              .withValues(alpha: dark ? 0.035 : 0.032),
                    ),
                  ),
                ),
              ),
            ),
            if (!dark)
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _FieldTilePainter(
                        color: AppTheme.earthBrown.withValues(alpha: 0.034),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.68, -0.76),
                      radius: ResponsiveLayout.isDesktop(context) ? 1.0 : 1.35,
                      colors: [
                        (dark ? AppTheme.metallicGold : Colors.white)
                            .withValues(alpha: dark ? 0.12 : 0.36),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!dark)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.82, 0.72),
                        radius:
                            ResponsiveLayout.isDesktop(context) ? 1.08 : 1.4,
                        colors: [
                          AppTheme.forestGreen.withValues(alpha: 0.112),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.15,
                      colors: [
                        Colors.transparent,
                        palette.pageBackground
                            .withValues(alpha: dark ? 0.30 : 0.19),
                      ],
                      stops: const [0.58, 1],
                    ),
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _FieldTilePainter extends CustomPainter {
  final Color color;

  const _FieldTilePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final gap = size.width < 600 ? 52.0 : 70.0;

    for (var x = -gap; x < size.width + gap; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + gap * 0.58, size.height), paint);
    }
    for (var y = -gap; y < size.height + gap; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + gap * 0.35), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FieldTilePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _OrganicTexturePainter extends CustomPainter {
  final Color color;

  const _OrganicTexturePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path();
    final rowGap = size.width < 600 ? 72.0 : 96.0;
    final amplitude = size.width < 600 ? 12.0 : 18.0;

    for (var y = -rowGap; y < size.height + rowGap; y += rowGap) {
      path.reset();
      path.moveTo(-24, y);
      for (var x = 0.0; x <= size.width + 48; x += 96) {
        path.quadraticBezierTo(
          x + 32,
          y + amplitude,
          x + 96,
          y + ((x ~/ 96).isEven ? -amplitude : amplitude),
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrganicTexturePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class ResponsivePage extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsivePage({
    super.key,
    required this.child,
    this.scrollable = true,
    this.maxWidth,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    final pagePadding = ResponsiveLayout.pagePadding(context);
    final resolvedPadding = padding ?? EdgeInsets.all(pagePadding);

    Widget buildContent({double? minHeight}) {
      return Padding(
        padding: resolvedPadding,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? ResponsiveLayout.contentMaxWidth(context),
              minHeight: minHeight ?? 0,
            ),
            child: child,
          ),
        ),
      );
    }

    if (!scrollable) {
      return SafeArea(
        top: false,
        child: buildContent(),
      );
    }

    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final verticalPadding =
              resolvedPadding.resolve(Directionality.of(context)).vertical;
          final minHeight = constraints.maxHeight.isFinite
              ? (constraints.maxHeight - verticalPadding)
                  .clamp(0.0, double.infinity)
              : 0.0;

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: buildContent(minHeight: minHeight),
          );
        },
      ),
    );
  }
}

class ResponsiveForm extends StatelessWidget {
  final List<Widget> children;
  final GlobalKey<FormState>? formKey;
  final double? maxWidth;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveForm({
    super.key,
    required this.children,
    this.formKey,
    this.maxWidth,
    this.spacing = AppSpacing.lg,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: _separate(children, SizedBox(height: spacing)),
      ),
    );

    return ResponsivePage(
      maxWidth: maxWidth ?? ResponsiveLayout.formMaxWidth(context),
      child: form,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? columns;
  final double spacing;
  final double runSpacing;
  final double minChildWidth;
  final bool dense;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.columns,
    this.spacing = AppSpacing.lg,
    this.runSpacing = AppSpacing.lg,
    this.minChildWidth = 280,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final usableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final preferredColumns = columns ??
            ResponsiveLayout.gridColumns(
              context,
              desktop: usableWidth >= 1280 ? 4 : 3,
            );
        final maxColumnsByWidth =
            (usableWidth / minChildWidth).floor().clamp(1, preferredColumns);
        final columnCount =
            preferredColumns.clamp(1, maxColumnsByWidth).toInt();
        final itemWidth =
            (usableWidth - (spacing * (columnCount - 1))) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: dense ? WrapAlignment.start : WrapAlignment.spaceBetween,
          children: children
              .map(
                (child) => SizedBox(
                  width: columnCount == 1 ? usableWidth : itemWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class AppSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool featured;

  const AppSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return _InteractiveSurface(
      onTap: onTap,
      padding: padding,
      featured: featured,
      child: child,
    );
  }
}

class _InteractiveSurface extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool featured;

  const _InteractiveSurface({
    required this.child,
    required this.padding,
    required this.featured,
    this.onTap,
  });

  @override
  State<_InteractiveSurface> createState() => _InteractiveSurfaceState();
}

class _InteractiveSurfaceState extends State<_InteractiveSurface> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.featured ? 16 : 12);
    final lift = widget.onTap != null && (_hovered || _pressed);
    final scale = _pressed ? 0.992 : 1.0;

    final surface = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: AppTheme.cardDecoration(
        context,
        featured: widget.featured,
        elevated: lift,
      ),
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
    );

    final animated = AnimatedScale(
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      scale: scale,
      child: surface,
    );

    if (widget.onTap == null) return animated;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            child: animated,
          ),
        ),
      ),
    );
  }
}

class ResponsiveSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const ResponsiveSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final typeScale = ResponsiveLayout.typeScale(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: palette.primaryText,
                          fontSize: 20 * typeScale,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: palette.secondaryText,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        child,
      ],
    );
  }
}

List<Widget> _separate(List<Widget> children, Widget separator) {
  if (children.isEmpty) return children;
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) separator,
      children[i],
    ],
  ];
}
