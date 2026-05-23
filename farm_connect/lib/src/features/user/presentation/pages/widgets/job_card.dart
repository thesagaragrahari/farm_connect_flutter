import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/features/jobs/domain/entities/job_summary.dart';

class JobCard extends StatelessWidget {
  final JobSummary job;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.appText(context);
    final mutedColor = AppTheme.appMutedText(context);
    return AppSurface(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            job.assignedWorkerName == null
                ? 'Worker assignment pending'
                : 'Worker: ${job.assignedWorkerName}',
            style: TextStyle(color: mutedColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Status: ${job.status ?? 'Open'}',
            style: TextStyle(color: mutedColor),
          ),
          if (job.location != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Location: ${job.location}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: mutedColor),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: onTap,
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
}
