import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/profile_section_card.dart';
import 'widgets/setting_switch_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(userControllerProvider);
    final profile = asyncState.value?.profile;
    final settings = profile?.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: asyncState.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ProfileSectionCard(
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                  child: Column(
                    children: [
                      SettingSwitchTile(
                        title: 'Push notifications',
                        subtitle: 'Receive profile and job updates',
                        value: settings?.notificationsEnabled ?? true,
                        onChanged: (value) {
                          ref.read(userControllerProvider.notifier).updateNotificationSettings(
                                notificationsEnabled: value,
                                jobAlertsEnabled: settings?.jobAlertsEnabled ?? true,
                              );
                        },
                      ),
                      SettingSwitchTile(
                        title: 'Job alerts',
                        subtitle: 'Get notified about matching farm work',
                        value: settings?.jobAlertsEnabled ?? true,
                        onChanged: (value) {
                          ref.read(userControllerProvider.notifier).updateNotificationSettings(
                                notificationsEnabled:
                                    settings?.notificationsEnabled ?? true,
                                jobAlertsEnabled: value,
                              );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ProfileSectionCard(
                  title: 'Privacy',
                  icon: Icons.privacy_tip_outlined,
                  child: Column(
                    children: [
                      SettingSwitchTile(
                        title: 'Public profile',
                        subtitle: 'Allow farmers and workers to view your profile',
                        value: settings?.profileVisible ?? true,
                        onChanged: (value) {
                          ref.read(userControllerProvider.notifier).updatePrivacySettings(
                                profileVisible: value,
                                showPhoneNumber: settings?.showPhoneNumber ?? false,
                              );
                        },
                      ),
                      SettingSwitchTile(
                        title: 'Show phone number',
                        subtitle: 'Display phone on your public profile',
                        value: settings?.showPhoneNumber ?? false,
                        onChanged: (value) {
                          ref.read(userControllerProvider.notifier).updatePrivacySettings(
                                profileVisible: settings?.profileVisible ?? true,
                                showPhoneNumber: value,
                              );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _showDeactivateInfo(context),
                  icon: const Icon(Icons.block_outlined),
                  label: const Text('Deactivate account'),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'LOG OUT',
                  trailingIcon: Icons.logout_rounded,
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ],
            ),
    );
  }

  void _showDeactivateInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate account'),
        content: const Text(
          'Account deactivation is prepared for backend support and will be enabled after admin review flow is connected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
