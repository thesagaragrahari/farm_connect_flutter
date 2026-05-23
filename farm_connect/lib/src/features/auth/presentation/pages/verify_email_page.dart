import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final tokenController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final message = await ref
          .read(authControllerProvider.notifier)
          .verifyEmail(tokenController.text.trim());
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
      title: 'Verify Email',
      subtitle:
          'Paste the verification token from your email to activate account.',
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
              label: 'Verification Token',
              hint: 'Paste token here',
              prefixIcon: Icons.mark_email_read_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Token is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'VERIFY EMAIL',
              isLoading: _isSubmitting,
              trailingIcon: Icons.check_circle_outline_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
