import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/theme/app_palette.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserModulePreviewPage extends StatefulWidget {
  const UserModulePreviewPage({super.key});

  @override
  State<UserModulePreviewPage> createState() => _UserModulePreviewPageState();
}

class _UserModulePreviewPageState extends State<UserModulePreviewPage> {
  int selectedTab = 0;

  static const _tabs = <_HubTab>[
    _HubTab(label: 'Auth', icon: Icons.lock_rounded),
    _HubTab(label: 'Home', icon: Icons.home_rounded),
    _HubTab(label: 'Workers', icon: Icons.groups_2_rounded),
    _HubTab(label: 'Jobs', icon: Icons.work_rounded),
    _HubTab(label: 'Profile', icon: Icons.person_rounded),
    _HubTab(label: 'Settings', icon: Icons.settings_rounded),
  ];

  static const _routes = <_HubRoute>[
    _HubRoute(
      title: 'Splash Screen',
      subtitle: 'Animated launch experience',
      path: AppRoutes.splash,
      icon: Icons.auto_awesome_rounded,
      tabIndex: 0,
    ),
    _HubRoute(
      title: 'Login',
      subtitle: 'Secure email and password access',
      path: AppRoutes.login,
      icon: Icons.login_rounded,
      tabIndex: 0,
    ),
    _HubRoute(
      title: 'Signup',
      subtitle: 'Create a farmer or worker account',
      path: AppRoutes.signup,
      icon: Icons.person_add_rounded,
      tabIndex: 0,
    ),
    _HubRoute(
      title: 'Password Help',
      subtitle: 'Reset and verify account access',
      path: AppRoutes.forgotPassword,
      icon: Icons.lock_reset_rounded,
      tabIndex: 0,
    ),
    _HubRoute(
      title: 'Farmer Dashboard',
      subtitle: 'Main workspace for daily farm operations',
      path: AppRoutes.farmerDashboard,
      icon: Icons.dashboard_rounded,
      tabIndex: 1,
    ),
    _HubRoute(
      title: 'Active Workers',
      subtitle: 'Find available workers by skill and location',
      path: AppRoutes.activeUsers,
      icon: Icons.people_alt_rounded,
      tabIndex: 2,
    ),
    _HubRoute(
      title: 'Post Job',
      subtitle: 'Create a farm job request',
      path: AppRoutes.postJob,
      icon: Icons.add_business_rounded,
      tabIndex: 3,
    ),
    _HubRoute(
      title: 'Manage Jobs',
      subtitle: 'Track active, upcoming and past work',
      path: AppRoutes.manageJobs,
      icon: Icons.view_kanban_rounded,
      tabIndex: 3,
    ),
    _HubRoute(
      title: 'Profile',
      subtitle: 'Manage personal and role information',
      path: AppRoutes.profile,
      icon: Icons.account_circle_rounded,
      tabIndex: 4,
    ),
    _HubRoute(
      title: 'Edit Profile',
      subtitle: 'Update contact, bio and address details',
      path: AppRoutes.editProfile,
      icon: Icons.edit_rounded,
      tabIndex: 4,
    ),
    _HubRoute(
      title: 'Worker Details',
      subtitle: 'Skills, availability, wage and radius',
      path: AppRoutes.workerProfile,
      icon: Icons.engineering_rounded,
      tabIndex: 4,
    ),
    _HubRoute(
      title: 'Farmer Details',
      subtitle: 'Farm type, land size and hiring preferences',
      path: AppRoutes.farmerProfile,
      icon: Icons.agriculture_rounded,
      tabIndex: 4,
    ),
    _HubRoute(
      title: 'Settings',
      subtitle: 'Notifications, privacy and account controls',
      path: AppRoutes.settings,
      icon: Icons.tune_rounded,
      tabIndex: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final routes = _routes
        .where((route) => route.tabIndex == selectedTab)
        .toList(growable: false);

    return Scaffold(
      appBar: appTopBar(
        title: const Text('FarmConnect'),
        actions: [
          IconButton(
            tooltip: 'Sign in',
            onPressed: () => context.push(AppRoutes.login),
            icon: const Icon(Icons.login_rounded),
          ),
        ],
      ),
      body: AppScreen(
        child: ResponsivePage(
          maxWidth: ResponsiveLayout.dashboardMaxWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSummary(palette: palette),
              const SizedBox(height: AppSpacing.xl),
              _AdaptiveTabBar(
                tabs: _tabs,
                selectedIndex: selectedTab,
                onChanged: (index) => setState(() => selectedTab = index),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _RouteGrid(
                  key: ValueKey(selectedTab),
                  routes: routes,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ResponsiveLayout.isMobile(context)
          ? NavigationBar(
              selectedIndex: selectedTab,
              onDestinationSelected: (index) =>
                  setState(() => selectedTab = index),
              destinations: _tabs
                  .map(
                    (tab) => NavigationDestination(
                      icon: Icon(tab.icon),
                      label: tab.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}

class _HeroSummary extends StatelessWidget {
  final AppPalette palette;

  const _HeroSummary({required this.palette});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Farm work, organized.',
          style: textTheme.headlineMedium?.copyWith(
            color: palette.primaryText,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'A responsive workspace for farmers and workers to manage jobs, profiles and availability.',
          style: textTheme.bodyLarge?.copyWith(
            color: palette.secondaryText,
          ),
        ),
      ],
    );

    return AppSurface(
      featured: true,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: copy,
    );
  }
}

class _AdaptiveTabBar extends StatelessWidget {
  final List<_HubTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _AdaptiveTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isMobile(context)) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(tabs.length, (index) {
        final selected = selectedIndex == index;
        return ChoiceChip(
          selected: selected,
          avatar: Icon(tabs[index].icon, size: 18),
          label: Text(tabs[index].label),
          onSelected: (_) => onChanged(index),
        );
      }),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final _HubRoute route;
  final bool featured;

  const _RouteCard(this.route, {this.featured = false});

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final iconColor =
        AppTheme.isDark(context) ? AppTheme.metallicGold : AppTheme.forestGreen;

    return AppSurface(
      featured: featured,
      padding: EdgeInsets.all(featured ? AppSpacing.xxl : AppSpacing.lg),
      onTap: () => context.push(route.path),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final vertical = featured || constraints.maxWidth >= 360;

          if (vertical) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: featured ? 28 : 24,
                  backgroundColor: iconColor.withValues(alpha: 0.14),
                  child: Icon(route.icon, color: iconColor),
                ),
                SizedBox(height: featured ? AppSpacing.xl : AppSpacing.lg),
                Text(
                  route.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: palette.primaryText,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  route.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: palette.secondaryText,
                      ),
                ),
                SizedBox(height: featured ? AppSpacing.xl : AppSpacing.lg),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: palette.secondaryText,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withValues(alpha: 0.14),
                child: Icon(route.icon, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: palette.primaryText,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      route.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: palette.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.chevron_right_rounded, color: palette.secondaryText),
            ],
          );
        },
      ),
    );
  }
}

class _RouteGrid extends StatelessWidget {
  final List<_HubRoute> routes;

  const _RouteGrid({
    super.key,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 980;

        if (!desktop || routes.length < 3) {
          return ResponsiveGrid(
            minChildWidth: 260,
            children: [
              for (var i = 0; i < routes.length; i++)
                _RouteCard(routes[i], featured: i == 0),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: _RouteCard(routes.first, featured: true)),
            const SizedBox(width: AppSpacing.xxl),
            Expanded(
              flex: 7,
              child: ResponsiveGrid(
                columns: 2,
                minChildWidth: 220,
                children: routes.skip(1).map(_RouteCard.new).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HubTab {
  final String label;
  final IconData icon;

  const _HubTab({
    required this.label,
    required this.icon,
  });
}

class _HubRoute {
  final String title;
  final String subtitle;
  final String path;
  final IconData icon;
  final int tabIndex;

  const _HubRoute({
    required this.title,
    required this.subtitle,
    required this.path,
    required this.icon,
    required this.tabIndex,
  });
}
