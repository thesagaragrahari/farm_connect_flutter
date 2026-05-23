import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:farm_connect/src/features/auth/domain/entities/auth_session.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/auth_shell.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/widgets/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role (Farmer/Worker).')),
      );
      return;
    }

    await ref.read(authControllerProvider.notifier).login(
          emailController.text.trim(),
          passwordController.text,
          selectedRole!,
        );
  }

  void _showVerificationPopup(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VerificationView(
        email: email,
        onResend: () async {
          try {
            final message = await ref
                .read(authControllerProvider.notifier)
                .resendVerification(
                  email,
                );
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildRoleSelector() {
    const roles = <String>['farmer', 'worker'];
    final muted = AppTheme.appMutedText(context);
    final text = AppTheme.appText(context);
    final surface = AppTheme.appSurfaceAlt(context);
    final accent =
        AppTheme.isDark(context) ? AppTheme.metallicGold : AppTheme.forestGreen;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role',
          style: TextStyle(
            color: muted,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: roles.map((role) {
            final isSelected = selectedRole == role;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: role == 'farmer' ? 10 : 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? accent.withValues(alpha: 0.18) : surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected ? accent : muted.withValues(alpha: 0.28),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => selectedRole = role),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            role == 'farmer'
                                ? Icons.agriculture_rounded
                                : Icons.engineering_rounded,
                            size: 18,
                            color: isSelected ? accent : muted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            role[0].toUpperCase() + role.substring(1),
                            style: TextStyle(
                              color: isSelected ? text : muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    ref.listen<AsyncValue<AuthSession?>>(authControllerProvider, (_, next) {
      next.whenOrNull(
        data: (session) {
          if (session != null && mounted) context.go(AppRoutes.dashboard);
        },
        error: (error, _) {
          final errorMsg = error.toString();
          if (errorMsg.toLowerCase().contains('verify')) {
            _showVerificationPopup(emailController.text.trim());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
            );
          }
        },
      );
    });

    final authState = ref.watch(authControllerProvider);

    return AuthShell(
      title: 'Welcome Back',
      subtitle: 'Login to continue farming smarter with your community.',
      footerActions: [
        TextButton(
          onPressed: () => context.go(AppRoutes.forgotPassword),
          child: const Text('Forgot password?'),
        ),
        TextButton(
          onPressed: () => context.go(AppRoutes.signup),
          child: const Text('Create new account'),
        ),
        TextButton(
          onPressed: () => context.go(AppRoutes.verifyEmail),
          child: const Text('Verify email with token'),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: emailController,
              label: 'Email',
              hint: 'name@example.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
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
              hint: 'Enter your password',
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
            const SizedBox(height: 26),
            PrimaryButton(
              text: 'LOG IN',
              isLoading: authState.isLoading,
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: _handleLogin,
            ),
          ],
        ),
      ),
    );
  }
}
