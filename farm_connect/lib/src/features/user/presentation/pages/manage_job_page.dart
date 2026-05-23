import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/features/jobs/application/job_controller.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageJobsPage extends StatelessWidget {
  const ManageJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appTopBar(
          title: const Text('Manage Jobs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Past'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _JobsTab(status: 'active'),
            _JobsTab(status: 'past'),
            _JobsTab(status: 'upcoming'),
          ],
        ),
      ),
    );
  }
}

class _JobsTab extends ConsumerWidget {
  final String status;

  const _JobsTab({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(jobsProvider(status));

    return AppScreen(
      child: ResponsivePage(
        maxWidth: 1180,
        child: jobs.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _JobsStateCard(
            title: 'Jobs unavailable',
            message: userMessageForJobError(error),
            onRetry: () => ref.invalidate(jobsProvider(status)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _JobsStateCard(
                title: 'No ${status.toLowerCase()} jobs',
                message: 'Jobs from the backend will appear here.',
                onRetry: () => ref.invalidate(jobsProvider(status)),
              );
            }

            return ResponsiveSection(
              title: 'Job Pipeline',
              subtitle: 'Live backend data for ${status.toLowerCase()} jobs.',
              child: ResponsiveGrid(
                minChildWidth: 300,
                children: items.map((job) => JobCard(job: job)).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _JobsStateCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const _JobsStateCard({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppSurface(
        featured: true,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.work_off_outlined, size: 42),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
