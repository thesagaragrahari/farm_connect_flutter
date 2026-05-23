import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/auth_controller.dart';
import 'widgets/auth_background.dart';
import 'widgets/auth_shell.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      loading: () => Scaffold(
        backgroundColor: AppTheme.appBackground(context),
        body: const AuthBackground(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppTheme.appBackground(context),
        body: AuthBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Error loading session: $e',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.appText(context)),
              ),
            ),
          ),
        ),
      ),
      data: (session) {
        if (session == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/login');
          });
          return const SizedBox.shrink();
        }

        return AuthShell(
          title: 'Dashboard',
          subtitle: 'You are securely logged in to KrishiSetu.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Token',
                      style: TextStyle(
                        color: AppTheme.appMutedText(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _maskedToken(session.token),
                      style: TextStyle(
                        color: AppTheme.appText(context),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: session.token),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token copied to clipboard.')),
                  );
                },
                icon: const Icon(Icons.copy_all_rounded),
                label: const Text('Copy full token'),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                text: 'LOG OUT',
                trailingIcon: Icons.logout_rounded,
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).logout(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _maskedToken(String token) {
    if (token.length <= 12) return token;
    return '${token.substring(0, 8)}...${token.substring(token.length - 4)}';
  }
}
