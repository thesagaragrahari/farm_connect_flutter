import 'package:farm_connect/src/features/user/presentation/pages/widgets/dashboard_action_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FarmerDashboardPage extends StatelessWidget {
  const FarmerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Connect'),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DashboardActionCard(
              title: 'View Active Users',
              icon: Icons.people_alt_outlined,
              onTap: () => context.push('/active-users'),
            ),
            const SizedBox(height: 16),
            DashboardActionCard(
              title: 'Post Job',
              icon: Icons.work_outline_rounded,
              onTap: () => context.push('/post-job'),
            ),
            const SizedBox(height: 16),
            DashboardActionCard(
              title: 'Manage Jobs',
              icon: Icons.dashboard_outlined,
              onTap: () => context.push('/manage-jobs'),
            ),
            const SizedBox(height: 16),
            DashboardActionCard(
              title: 'Profile',
              icon: Icons.person_outline,
              onTap: () => context.push('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}