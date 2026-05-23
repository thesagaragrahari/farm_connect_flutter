import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    tokenController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final message =
          await ref.read(authControllerProvider.notifier).resetPassword(
                token: tokenController.text.trim(),
                newPassword: newPasswordController.text,
              );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Reset Password',
      subtitle: 'Paste your token and choose a fresh secure password.',
      footerActions: [
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: const Text('Back to login'),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: tokenController,
              label: 'Reset Token',
              hint: 'Paste token from email',
              prefixIcon: Icons.vpn_key_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Token is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: newPasswordController,
              label: 'New Password',
              hint: 'Choose a strong new password',
              prefixIcon: Icons.lock_reset_outlined,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'RESET PASSWORD',
              isLoading: _isSubmitting,
              trailingIcon: Icons.verified_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
