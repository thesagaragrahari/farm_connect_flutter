import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/features/jobs/application/job_controller.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/job_card.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PublicJobPreviewPage extends ConsumerWidget {
  final String jobId;

  const PublicJobPreviewPage({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobState = ref.watch(publicJobProvider(jobId));

    return Scaffold(
      appBar: appTopBar(title: const Text('Public Job Preview')),
      body: AppScreen(
        child: ResponsivePage(
          maxWidth: 760,
          child: jobState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _PreviewStateCard(
              title: 'Job unavailable',
              message: userMessageForJobError(error),
              onBack: () => context.go(AppRoutes.preview),
            ),
            data: (job) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                JobCard(job: job),
                const SizedBox(height: AppSpacing.lg),
                AppSurface(
                  child: Text(
                    job.description?.trim().isNotEmpty == true
                        ? job.description!
                        : 'No public job description was published.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewStateCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onBack;

  const _PreviewStateCard({
    required this.title,
    required this.message,
    required this.onBack,
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
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to preview'),
            ),
          ],
        ),
      ),
    );
  }
}
