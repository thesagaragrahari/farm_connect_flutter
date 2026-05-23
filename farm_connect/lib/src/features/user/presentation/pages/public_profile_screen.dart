import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:farm_connect/src/features/user/domain/entities/user_profile_details.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/profile_info_row.dart';
import 'widgets/profile_section_card.dart';

final publicProfileProvider = FutureProvider.family<UserProfileDetails, String>(
  (ref, userId) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('Invalid public profile link.');
    }
    return ref.read(userRepositoryProvider).getPublicProfile(userId);
  },
);

class PublicProfileScreen extends ConsumerWidget {
  final String userId;

  const PublicProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(publicProfileProvider(userId));

    return Scaffold(
      appBar: appTopBar(title: const Text('Public Profile')),
      body: AppScreen(
        child: profileState.when(
          loading: () => const _PublicProfileStateCard.loading(),
          error: (e, _) => _PublicProfileStateCard.error(message: e.toString()),
          data: (profile) => _PublicProfileContent(profile: profile),
        ),
      ),
    );
  }
}

class _PublicProfileContent extends StatelessWidget {
  final UserProfileDetails profile;

  const _PublicProfileContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final worker = profile.workerProfile;

    return ResponsivePage(
      maxWidth: ResponsiveLayout.dashboardMaxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PublicProfileHeader(profile: profile),
          const SizedBox(height: AppSpacing.xl),
          ResponsiveGrid(
            minChildWidth: 300,
            children: [
              ProfileSectionCard(
                title: 'About',
                icon: Icons.notes_outlined,
                child: Text(
                  _publicText(profile.bio, fallback: 'No public bio yet.'),
                ),
              ),
              if (worker != null)
                ProfileSectionCard(
                  title: 'Skill Showcase',
                  icon: Icons.engineering_outlined,
                  child: worker.skills.isEmpty
                      ? const Text('Skills will appear here once published.')
                      : Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: worker.skills
                              .map((skill) => Chip(label: Text(skill)))
                              .toList(),
                        ),
                ),
              ProfileSectionCard(
                title: 'Activity Preview',
                icon: Icons.timeline_rounded,
                child: const Text(
                  'Completed work, reviews and recent activity will appear here as the profile grows.',
                ),
              ),
              if (worker != null)
                ProfileSectionCard(
                  title: 'Worker Details',
                  icon: Icons.work_outline_rounded,
                  child: Column(
                    children: [
                      ProfileInfoRow(
                        label: 'Experience',
                        value: _publicText(worker.experience),
                      ),
                      ProfileInfoRow(
                        label: 'Work type',
                        value: _publicText(worker.preferredWorkType),
                      ),
                      ProfileInfoRow(
                        label: 'Work radius',
                        value: _publicText(worker.workRadius),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PublicProfileHeader extends StatelessWidget {
  final UserProfileDetails profile;

  const _PublicProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final worker = profile.workerProfile;
    final avatarSize = ResponsiveLayout.isMobile(context) ? 84.0 : 104.0;
    final role = _publicText(profile.role, fallback: 'Community Member');
    final location = _publicText(profile.location, fallback: 'Location hidden');

    return AppSurface(
      featured: true,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProfileAvatar(profile: profile, size: avatarSize),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$role • $location',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          );
          final stats = Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _PreviewStat(label: 'Visibility', value: 'Public'),
              _PreviewStat(
                label: 'Profile',
                value: '${profile.profileCompletion}%',
              ),
              if (worker != null)
                _PreviewStat(
                  label: 'Availability',
                  value: worker.isAvailable ? 'Open' : 'Limited',
                ),
            ],
          );

          if (wide) {
            return Row(
              children: [
                Expanded(flex: 5, child: identity),
                const SizedBox(width: AppSpacing.xxl),
                Expanded(flex: 3, child: stats),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              identity,
              const SizedBox(height: AppSpacing.xl),
              stats,
            ],
          );
        },
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final UserProfileDetails profile;
  final double size;

  const _ProfileAvatar({
    required this.profile,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = profile.profileImageUrl;

    return SizedBox.square(
      dimension: size,
      child: CircleAvatar(
        backgroundImage: imageUrl == null || imageUrl.isEmpty
            ? null
            : NetworkImage(imageUrl),
        child: imageUrl == null || imageUrl.isEmpty
            ? Icon(Icons.person_outline_rounded, size: size * 0.46)
            : null,
      ),
    );
  }
}

class _PreviewStat extends StatelessWidget {
  final String label;
  final String value;

  const _PreviewStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);

    return AppSurface(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.secondaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.primaryText,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _PublicProfileStateCard extends StatelessWidget {
  final bool loading;
  final String? message;

  const _PublicProfileStateCard.loading()
      : loading = true,
        message = null;

  const _PublicProfileStateCard.error({required this.message})
      : loading = false;

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      maxWidth: 560,
      child: Center(
        child: AppSurface(
          featured: true,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                const CircularProgressIndicator()
              else
                const Icon(Icons.person_off_outlined, size: 42),
              const SizedBox(height: AppSpacing.lg),
              Text(
                loading ? 'Loading Public Profile' : 'Profile Unavailable',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!loading) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message ?? 'This public profile could not be loaded.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.preview),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to preview'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _publicText(String? value, {String fallback = 'Not published'}) {
  final text = value?.trim();
  return text == null || text.isEmpty ? fallback : text;
}
