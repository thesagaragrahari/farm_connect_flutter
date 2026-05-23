import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/features/dashboard/application/dashboard_controller.dart';
import 'package:farm_connect/src/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/dashboard_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmerDashboardPage extends ConsumerWidget {
  const FarmerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: appTopBar(
        title: const Text('Farm Connect'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      body: AppScreen(
        child: ResponsivePage(
          maxWidth: ResponsiveLayout.dashboardMaxWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DashboardHero(summary: summary),
              const SizedBox(height: AppSpacing.xxl),
              LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth >= 980;
                  final actions = [
                    DashboardActionCard(
                      title: 'View Active Workers',
                      subtitle:
                          'Find nearby help by skill, availability and location.',
                      icon: Icons.people_alt_outlined,
                      featured: !desktop,
                      onTap: () => context.push(AppRoutes.activeUsers),
                    ),
                    DashboardActionCard(
                      title: 'Post Job',
                      subtitle:
                          'Create a work request with wage and field details.',
                      icon: Icons.work_outline_rounded,
                      onTap: () => context.push(AppRoutes.postJob),
                    ),
                    DashboardActionCard(
                      title: 'Manage Jobs',
                      subtitle:
                          'Track active, upcoming and completed farm work.',
                      icon: Icons.dashboard_outlined,
                      onTap: () => context.push(AppRoutes.manageJobs),
                    ),
                    DashboardActionCard(
                      title: 'Profile',
                      subtitle:
                          'Keep identity, role and farm information current.',
                      icon: Icons.person_outline,
                      onTap: () => context.push(AppRoutes.profile),
                    ),
                    DashboardActionCard(
                      title: 'Settings',
                      subtitle:
                          'Control alerts, privacy and account preferences.',
                      icon: Icons.settings_outlined,
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                  ];

                  if (!desktop) {
                    return ResponsiveSection(
                      title: 'Workspace',
                      subtitle:
                          'Quick actions sized for the screen you are using.',
                      child: ResponsiveGrid(
                        minChildWidth: 250,
                        children: actions,
                      ),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: DashboardActionCard(
                          title: 'View Active Workers',
                          subtitle:
                              'Discover available workers, compare skills and open public profiles from a dedicated responsive workspace.',
                          icon: Icons.people_alt_outlined,
                          featured: true,
                          onTap: () => context.push(AppRoutes.activeUsers),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxl),
                      Expanded(
                        flex: 7,
                        child: ResponsiveSection(
                          title: 'Daily Operations',
                          child: ResponsiveGrid(
                            columns: 2,
                            minChildWidth: 220,
                            children: actions.skip(1).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final AsyncValue<DashboardSummary> summary;

  const _DashboardHero({required this.summary});

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final typeScale = ResponsiveLayout.typeScale(context);

    return AppSurface(
      featured: true,
      padding: EdgeInsets.all(
        ResponsiveLayout.isMobile(context) ? AppSpacing.xl : AppSpacing.xxxl,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today at a glance',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: palette.primaryText,
                      fontSize: 28 * typeScale,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'A premium farm operations workspace for workers, jobs and profile readiness.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.secondaryText,
                    ),
              ),
            ],
          );

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                const SizedBox(height: AppSpacing.xl),
                _QuickStats(summary: summary),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 6, child: copy),
              const SizedBox(width: AppSpacing.xxl),
              Expanded(flex: 5, child: _QuickStats(summary: summary)),
            ],
          );
        },
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final AsyncValue<DashboardSummary> summary;

  const _QuickStats({required this.summary});

  @override
  Widget build(BuildContext context) {
    return summary.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const _DashboardStateText(
        message: 'Dashboard metrics are unavailable.',
      ),
      data: (data) => Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          _StatTile(
            label: 'Workers',
            value: data.activeWorkers.toString(),
            icon: Icons.groups_rounded,
          ),
          _StatTile(
            label: 'Jobs',
            value: data.activeJobs.toString(),
            icon: Icons.work_rounded,
          ),
          _StatTile(
            label: 'Profile',
            value: '${data.profileCompletion}%',
            icon: Icons.verified_rounded,
          ),
        ],
      ),
    );
  }
}

class _DashboardStateText extends StatelessWidget {
  final String message;

  const _DashboardStateText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.palette(context).secondaryText,
          ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);
    final accent =
        AppTheme.isDark(context) ? AppTheme.metallicGold : AppTheme.forestGreen;

    return FractionallySizedBox(
      widthFactor: ResponsiveLayout.isMobile(context) ? 1 : null,
      child: Container(
        constraints: const BoxConstraints(minWidth: 150),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: palette.card.withValues(alpha: 0.64),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: accent, size: 20),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: palette.primaryText,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.secondaryText,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
