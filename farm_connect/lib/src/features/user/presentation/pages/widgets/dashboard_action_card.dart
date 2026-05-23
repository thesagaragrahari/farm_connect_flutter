import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/theme/app_theme.dart';

class DashboardActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.appText(context);
    final iconColor =
        AppTheme.isDark(context) ? AppTheme.metallicGold : AppTheme.forestGreen;

    return Container(
      decoration: AppTheme.cardDecoration(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: iconColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
