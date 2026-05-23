import 'dart:ui';

import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'theme_mode_toggle.dart';

PreferredSizeWidget appTopBar({
  required Widget title,
  List<Widget> actions = const [],
  List<AppTopBarNavigationItem> navigationItems = const [],
  PreferredSizeWidget? bottom,
}) {
  return PremiumAppBar(
    title: title,
    bottom: bottom,
    actions: actions,
    navigationItems: navigationItems,
  );
}

class AppTopBarNavigationItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const AppTopBarNavigationItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });
}

class PremiumAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const double toolbarHeight = 66;
  static const double maxContentWidth = 1320;

  final Widget title;
  final List<Widget> actions;
  final List<AppTopBarNavigationItem> navigationItems;
  final PreferredSizeWidget? bottom;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.navigationItems = const [],
    this.bottom,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(
      toolbarHeight + (bottom?.preferredSize.height ?? 0),
    );
  }

  @override
  State<PremiumAppBar> createState() => _PremiumAppBarState();
}

class _PremiumAppBarState extends State<PremiumAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final dark = AppTheme.isDark(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomHeight = widget.bottom?.preferredSize.height ?? 0;
    final toolbarHeight = PremiumAppBar.toolbarHeight;
    final totalHeight = topInset + toolbarHeight + bottomHeight;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final shimmer = _controller.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            height: totalHeight,
            decoration: BoxDecoration(
              color: palette.pageBackground,
              gradient: LinearGradient(
                begin: Alignment(-1 + shimmer * 0.35, -1),
                end: Alignment(1 - shimmer * 0.25, 1),
                colors: dark
                    ? const [
                        Color(0xFF07130B),
                        Color(0xFF12331B),
                        Color(0xFF0B1D10),
                      ]
                    : const [
                        Color(0xFFFFF9EC),
                        Color(0xFFEAF2DE),
                        Color(0xFFF3E0B4),
                      ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                      .withValues(alpha: dark ? 0.18 : 0.16),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? 0.22 : 0.09),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _AppBarTexturePainter(
                        progress: shimmer,
                        color: dark
                            ? AppTheme.metallicGold.withValues(alpha: 0.035)
                            : AppTheme.forestGreen.withValues(alpha: 0.035),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.55 + shimmer * 0.16, -0.9),
                          radius: 1.25,
                          colors: [
                            (dark ? AppTheme.metallicGold : Colors.white)
                                .withValues(alpha: dark ? 0.10 : 0.30),
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
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: dark ? 0.035 : 0.20),
                            Colors.transparent,
                            Colors.black.withValues(alpha: dark ? 0.12 : 0.035),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                child!,
              ],
            ),
          );
        },
        child: IconTheme.merge(
          data: IconThemeData(color: palette.primaryText),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: toolbarHeight + bottomHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: PreferredSize(
                          preferredSize: const Size.fromHeight(
                            PremiumAppBar.toolbarHeight,
                          ),
                          child: SizedBox(
                            height: toolbarHeight,
                            child: _AppBarToolbar(
                              title: widget.title,
                              actions: widget.actions,
                              navigationItems: widget.navigationItems,
                            ),
                          ),
                        ),
                      ),
                      if (widget.bottom != null)
                        PositionedDirectional(
                          start: 0,
                          end: 0,
                          bottom: 0,
                          height: bottomHeight,
                          child: SizedBox(
                            height: bottomHeight,
                            child: widget.bottom!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarToolbar extends StatelessWidget {
  final Widget title;
  final List<Widget> actions;
  final List<AppTopBarNavigationItem> navigationItems;

  const _AppBarToolbar({
    required this.title,
    required this.actions,
    required this.navigationItems,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveLayout.of(context);
    final compact = breakpoint == AppBreakpoint.mobile;
    final showCenterNav =
        breakpoint == AppBreakpoint.desktop && navigationItems.isNotEmpty;
    final horizontalPadding = compact ? AppSpacing.sm : AppSpacing.xxl;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: PremiumAppBar.maxContentWidth,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: horizontalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: showCenterNav ? 3 : 1,
                child: _AppBarLeadingSection(
                  title: title,
                  compact: compact,
                ),
              ),
              if (showCenterNav) ...[
                const Spacer(),
                Flexible(
                  flex: 4,
                  child: _AppBarNavigation(items: navigationItems),
                ),
                const Spacer(),
              ] else
                const SizedBox(width: AppSpacing.sm),
              Flexible(
                flex: 0,
                child: _AppBarActionSection(
                  actions: actions,
                  compact: compact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarLeadingSection extends StatelessWidget {
  final Widget title;
  final bool compact;

  const _AppBarLeadingSection({
    required this.title,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final maxWidth = compact ? 240.0 : 380.0;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minHeight: PremiumAppBar.toolbarHeight,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (canPop) ...[
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  tooltip: 'Back',
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),
            ],
            PremiumBrandIcon(size: compact ? 34 : 38),
            SizedBox(width: compact ? AppSpacing.sm : AppSpacing.md),
            Flexible(
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).appBarTheme.titleTextStyle ??
                    Theme.of(context).textTheme.titleLarge!,
                child: title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarNavigation extends StatelessWidget {
  final List<AppTopBarNavigationItem> items;

  const _AppBarNavigation({required this.items});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            for (final item in items) _AppBarNavigationButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _AppBarNavigationButton extends StatefulWidget {
  final AppTopBarNavigationItem item;

  const _AppBarNavigationButton({required this.item});

  @override
  State<_AppBarNavigationButton> createState() =>
      _AppBarNavigationButtonState();
}

class _AppBarNavigationButtonState extends State<_AppBarNavigationButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dark = AppTheme.isDark(context);
    final palette = AppTheme.palette(context);
    final active = widget.item.selected || _hovered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Tooltip(
          message: widget.item.label,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.item.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: active
                    ? (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                        .withValues(alpha: dark ? 0.15 : 0.11)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active
                      ? (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                          .withValues(alpha: dark ? 0.26 : 0.18)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.item.icon,
                    size: 18,
                    color: active
                        ? (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                        : palette.secondaryText,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    widget.item.label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: active
                              ? palette.primaryText
                              : palette.secondaryText,
                          fontWeight:
                              active ? FontWeight.w800 : FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarActionSection extends StatelessWidget {
  final List<Widget> actions;
  final bool compact;

  const _AppBarActionSection({
    required this.actions,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SizedBox(
        width: compact ? 156 : 340,
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const ThemeModeToggle(),
            ...actions.reversed,
          ],
        ),
      ),
    );
  }
}

class PremiumBrandIcon extends StatefulWidget {
  final double size;

  const PremiumBrandIcon({
    super.key,
    this.size = 38,
  });

  @override
  State<PremiumBrandIcon> createState() => _PremiumBrandIconState();
}

class _PremiumBrandIconState extends State<PremiumBrandIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      lowerBound: 0,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppTheme.isDark(context);
    final iconUrl = AppTheme.appIconUrlFor(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseScale = 1 + (_pulseController.value * 0.018);
          final scale = _hovered ? 1.045 : pulseScale;
          return AnimatedScale(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            scale: scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? const [
                      Color(0xFF13251A),
                      Color(0xFFD4A84F),
                      Color(0xFF2A1F11),
                    ]
                  : const [
                      Color(0xFFFFFFFF),
                      Color(0xFF245C27),
                      Color(0xFFE2C174),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: (dark ? AppTheme.metallicGold : AppTheme.forestGreen)
                    .withValues(alpha: dark ? 0.20 : 0.12),
                blurRadius: _hovered ? 18 : 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.size * 0.08),
            child: ClipOval(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Image.network(
                  iconUrl,
                  key: ValueKey(iconUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: dark ? const Color(0xFF102116) : Colors.white,
                    child: Icon(
                      Icons.eco_rounded,
                      color:
                          dark ? AppTheme.metallicGold : AppTheme.forestGreen,
                      size: widget.size * 0.54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTexturePainter extends CustomPainter {
  final double progress;
  final Color color;

  const _AppBarTexturePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final gap = size.width < 600 ? 44.0 : 58.0;
    final offset = progress * gap;

    for (var x = -size.height; x < size.width + size.height; x += gap) {
      canvas.drawLine(
        Offset(x + offset, size.height),
        Offset(x + size.height * 0.7 + offset, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AppBarTexturePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
