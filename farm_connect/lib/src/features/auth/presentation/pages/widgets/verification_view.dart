import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/theme/app_theme.dart';

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
    final textColor = AppTheme.appText(context);
    final mutedColor = AppTheme.appMutedText(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.appSurface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                color: mutedColor.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.metallicGold, width: 1.6),
              ),
              child: ClipOval(
                child: Image.network(
                  AppTheme.appIconUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/farm_connect_app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Verify Your Email',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We sent a verification link to\n$email',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
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
