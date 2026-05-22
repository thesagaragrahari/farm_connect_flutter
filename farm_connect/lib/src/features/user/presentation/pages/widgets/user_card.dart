import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:farm_connect/src/core/theme/app_theme.dart';
import '../../../domain/entities/user_profile_details.dart';

class UserCard extends StatelessWidget {
  final UserProfileDetails? user;

  const UserCard({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'Worker';
    final worker = user?.workerProfile;
    final subtitle = worker == null
        ? 'Farm worker'
        : '${worker.skills.take(2).join(', ')} • ${worker.experience ?? 'Experience not added'}';
    final textColor = AppTheme.appText(context);
    final mutedColor = AppTheme.appMutedText(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(context),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.isDark(context)
                ? AppTheme.metallicGold
                : AppTheme.forestGreen,
            child: const Icon(Icons.person_outline_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: mutedColor),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final id = user?.id;
              if (id != null && id.isNotEmpty) {
                context.push('/profile/public/$id');
                return;
              }
              context.push('/worker-profile');
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}
