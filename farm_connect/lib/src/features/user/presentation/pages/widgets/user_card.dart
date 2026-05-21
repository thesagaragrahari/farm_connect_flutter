import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132238),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            child: Icon(Icons.person_outline_rounded),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70),
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
