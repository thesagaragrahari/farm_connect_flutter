import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';

class DashboardActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool featured;

  const DashboardActionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.appText(context);
    final iconColor =
        AppTheme.isDark(context) ? AppTheme.metallicGold : AppTheme.forestGreen;

    return AppSurface(
      featured: featured,
      padding: EdgeInsets.all(featured ? AppSpacing.xxl : AppSpacing.lg),
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final roomy = constraints.maxWidth >= 360 || featured;

          if (roomy) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: AppTheme.subtleGlowDecoration(context),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: ResponsiveLayout.iconSize(context) + 2,
                    ),
                  ),
                ),
                SizedBox(height: featured ? AppSpacing.xl : AppSpacing.lg),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    maxLines: featured ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.appMutedText(context),
                        ),
                  ),
                ],
                SizedBox(height: featured ? AppSpacing.xl : AppSpacing.lg),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              Icon(icon,
                  color: iconColor, size: ResponsiveLayout.iconSize(context)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
    );
  }
}
