import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/theme/app_theme.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.appText(context);
    final mutedColor = AppTheme.appMutedText(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harvesting Job',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Worker Assigned: Ramesh Kumar',
            style: TextStyle(color: mutedColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Status: 98% Completed',
            style: TextStyle(color: mutedColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
}
