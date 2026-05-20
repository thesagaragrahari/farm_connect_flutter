import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'worker';
  bool _isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final message = await ref.read(authControllerProvider.notifier).signup(
            nameController.text.trim(),
            emailController.text.trim(),
            passwordController.text,
            role,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      context.go('/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildRoleSelector() {
    const roles = <String>['worker', 'farmer'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Role',
          style: TextStyle(
            color: kAuthTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: roles.map((item) {
            final selected = role == item;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: selected
                    ? kAuthAccent.withValues(alpha: 0.18)
                    : const Color(0xFF091528),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? kAuthAccent : const Color(0xFF1E3452),
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => role = item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item == 'farmer'
                            ? Icons.agriculture_rounded
                            : Icons.engineering_rounded,
                        size: 18,
                        color: selected ? kAuthAccent : const Color(0xFF9DB2CA),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item[0].toUpperCase() + item.substring(1),
                        style: TextStyle(
                          color: selected
                              ? kAuthTextPrimary
                              : const Color(0xFFB6C8DD),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Create Account',
      subtitle: 'Join KrishiSetu and unlock farmer-worker collaboration.',
      footerActions: [
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text('Back to login'),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              label: 'Email',
              hint: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              hint: 'Choose a strong password',
              isPassword: true,
              prefixIcon: Icons.lock_outline_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildRoleSelector(),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'SIGN UP',
              isLoading: _isSubmitting,
              trailingIcon: Icons.person_add_alt_1_rounded,
              onPressed: _submitSignup,
            ),
          ],
        ),
      ),
    );
  }
}
