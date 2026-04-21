import 'package:farm_connect/src/features/auth/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authControllerProvider);

    // If not logged in → redirect (you can also handle in router redirect)
    if (authAsync.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              // Optional: navigate after logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: ref.read(authControllerProvider.notifier).loadProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final profile = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, ${profile.name ?? "User"}', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                Text('Email: ${profile.email ?? "N/A"}'),
                // Add more profile fields as needed
              ],
            ),
          );
        },
      ),
    );
  }
}