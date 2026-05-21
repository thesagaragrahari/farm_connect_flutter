import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:farm_connect/src/features/user/domain/entities/user_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/profile_info_row.dart';
import 'widgets/profile_section_card.dart';

final publicProfileProvider = FutureProvider.family<UserProfileDetails, String>(
  (ref, userId) {
    return ref.read(userControllerProvider.notifier).getPublicProfile(userId);
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
      appBar: AppBar(title: const Text('Public Profile')),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(e.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.all(20),
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
              profile.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              '${profile.role ?? 'User'} • ${profile.location ?? 'Location not added'}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ProfileSectionCard(
              title: 'About',
              icon: Icons.notes_outlined,
              child: Text(profile.bio ?? 'No bio added yet.'),
            ),
            const SizedBox(height: 14),
            if (profile.workerProfile != null)
              ProfileSectionCard(
                title: 'Skill Showcase',
                icon: Icons.engineering_outlined,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.workerProfile!.skills
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
                ),
              ),
            if (profile.workerProfile != null) const SizedBox(height: 14),
            ProfileSectionCard(
              title: 'Ratings & Reviews',
              icon: Icons.star_border_rounded,
              child: const Text('Ratings and reviews will appear here after completed jobs.'),
            ),
            const SizedBox(height: 14),
            if (profile.workerProfile != null)
              ProfileSectionCard(
                title: 'Worker Details',
                icon: Icons.work_outline_rounded,
                child: Column(
                  children: [
                    ProfileInfoRow(
                      label: 'Experience',
                      value: profile.workerProfile!.experience ?? '',
                    ),
                    ProfileInfoRow(
                      label: 'Wage',
                      value: profile.workerProfile!.expectedWage?.toString() ?? '',
                    ),
                    ProfileInfoRow(
                      label: 'Work radius',
                      value: profile.workerProfile!.workRadius ?? '',
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
