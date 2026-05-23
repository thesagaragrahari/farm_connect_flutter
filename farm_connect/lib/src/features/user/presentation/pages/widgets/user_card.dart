import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
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

    return AppSurface(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 340;
          final avatar = CircleAvatar(
            radius: compact ? 24 : 28,
            backgroundColor: AppTheme.isDark(context)
                ? AppTheme.metallicGold
                : AppTheme.forestGreen,
            child:
                const Icon(Icons.person_outline_rounded, color: Colors.white),
          );
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: mutedColor),
              ),
            ],
          );
          final button = ElevatedButton(
            onPressed: () {
              final id = user?.id;
              if (id != null && id.isNotEmpty) {
                context.push(AppRoutes.previewProfile(id));
                return;
              }
              context.push(AppRoutes.workerProfile);
            },
            child: const Text('View'),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    avatar,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: details),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                button,
              ],
            );
          }

          return Row(
            children: [
              avatar,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: details),
              const SizedBox(width: AppSpacing.md),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: button,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
