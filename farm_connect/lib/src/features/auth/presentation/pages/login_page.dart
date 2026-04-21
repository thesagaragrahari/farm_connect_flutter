import 'package:farm_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farm_connect/src/core/constants/roles.dart';
// Note: Ensure this import points to your themeProvider in main.dart or a shared file
// import '/main.dart'; 

import '../../application/auth_controller.dart';

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
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);
    
    // Watch for theme changes
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final primaryGreen = const Color(0xFF4CAF50);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // THEME SWITCH
          Row(
            children: [
              Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 18),
              Switch(
                value: isDark,
                activeColor: primaryGreen,
                onChanged: (val) {
                  ref.read(themeProvider.notifier).state = 
                      val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Branding Header
              Text(
                'KRISHISETU',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              
              // Login Card (Automatically uses surface color from theme)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                  boxShadow: [
                    if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Account Login',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) => v != null && v.contains('@') ? null : 'Invalid email',
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => obscurePassword = !obscurePassword),
                          ),
                        ),
                        validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Role',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        value: selectedRole,
                        items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                        onChanged: (value) => setState(() => selectedRole = value),
                        validator: (value) => value == null ? 'Please select a role' : null,
                      ),
                      const SizedBox(height: 32),
                      
                      ElevatedButton(
                        onPressed: authController.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  authNotifier.login(
                                    emailController.text.trim(),
                                    passwordController.text,
                                    selectedRole!,
                                  );
                                }
                              },
                        child: authController.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('LOG IN', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text('Create Account', style: TextStyle(color: primaryGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}