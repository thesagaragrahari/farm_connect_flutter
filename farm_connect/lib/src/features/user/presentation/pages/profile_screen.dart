import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:farm_connect/src/features/user/domain/entities/user_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/profile_info_row.dart';
import 'widgets/profile_section_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ProfileError(message: e.toString()),
        data: (userState) {
          final profile = userState.profile;
          if (profile == null) {
            return const Center(child: Text('Profile not available.'));
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(userControllerProvider.notifier).refreshProfile(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _ProfileHeader(profile: profile),
                const SizedBox(height: 18),
                PrimaryButton(
                  text: 'EDIT PROFILE',
                  trailingIcon: Icons.edit_outlined,
                  onPressed: () => context.push('/profile/edit'),
                ),
                const SizedBox(height: 20),
                ProfileSectionCard(
                  title: 'Personal Details',
                  icon: Icons.person_outline_rounded,
                  child: Column(
                    children: [
                      ProfileInfoRow(label: 'Name', value: profile.fullName),
                      ProfileInfoRow(label: 'Email', value: profile.email),
                      ProfileInfoRow(label: 'Phone', value: profile.phone ?? ''),
                      ProfileInfoRow(label: 'Language', value: profile.language ?? ''),
                      ProfileInfoRow(label: 'Bio', value: profile.bio ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ProfileSectionCard(
                  title: 'Address',
                  icon: Icons.location_on_outlined,
                  child: Column(
                    children: [
                      ProfileInfoRow(label: 'Location', value: profile.location ?? ''),
                      ProfileInfoRow(label: 'Address', value: profile.address ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (profile.isWorker)
                  _RoleActionCard(
                    title: 'Worker Details',
                    subtitle: 'Skills, availability, wage and work radius',
                    icon: Icons.engineering_outlined,
                    onTap: () => context.push('/profile/worker'),
                  )
                else
                  _RoleActionCard(
                    title: 'Farmer Details',
                    subtitle: 'Farm type, land size and hiring preferences',
                    icon: Icons.agriculture_outlined,
                    onTap: () => context.push('/profile/farmer'),
                  ),
                const SizedBox(height: 14),
                _RoleActionCard(
                  title: 'Public Profile',
                  subtitle: 'Preview how your profile appears to others',
                  icon: Icons.badge_outlined,
                  onTap: () => context.push('/profile/public/${profile.id}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfileDetails profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundImage: profile.profileImageUrl == null
              ? null
              : NetworkImage(profile.profileImageUrl!),
          child: profile.profileImageUrl == null
              ? const Icon(Icons.person_outline_rounded, size: 44)
              : null,
        ),
        const SizedBox(height: 14),
        Text(
          profile.fullName.isEmpty ? 'Farm Connect User' : profile.fullName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          '${profile.role ?? 'User'} • ${profile.location ?? 'Location not added'}',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: profile.profileCompletion / 100,
          ),
        ),
        const SizedBox(height: 8),
        Text('${profile.profileCompletion}% profile complete'),
      ],
    );
  }
}

class _RoleActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String message;

  const _ProfileError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
