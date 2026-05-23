import 'package:flutter/material.dart';

class VerificationView extends StatelessWidget {
  final String email;
  final Future<void> Function() onResend;

  const VerificationView({
    super.key,
    required this.email,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1A2D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF33D17A), width: 1.6),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/farm_connect_app_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Verify Your Email',
              style: TextStyle(
                color: Color(0xFFEAF2FF),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We sent a verification link to\n$email',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9FB3CC),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async => onResend(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33D17A),
                  foregroundColor: const Color(0xFF03240F),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                icon: const Icon(Icons.mark_email_read_outlined),
                label: const Text(
                  'RESEND EMAIL',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
