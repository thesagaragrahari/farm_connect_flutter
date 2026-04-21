import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_controller.dart';

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
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup Failed: ${next.error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Optional: auto-redirect on success
      if (next.hasValue && next.value != null && previous?.value == null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Required',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v != null && v.contains('@') ? null : 'Invalid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: role,
                items: const ['worker', 'farmer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalize())))
                    .toList(),
                onChanged: (v) => setState(() => role = v!),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: authAsync.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authControllerProvider.notifier).signup(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text,
                                role,
                              );
                        }
                      },
                child: authAsync.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// Quick extension for capitalize (optional)
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}