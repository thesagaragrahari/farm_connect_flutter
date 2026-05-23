import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/theme/app_theme.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.appText(context);
    final mutedColor = AppTheme.appMutedText(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;
          final labelWidget = Text(
            label,
            style: TextStyle(
              color: mutedColor,
              fontWeight: FontWeight.w600,
            ),
          );
          final valueWidget = Text(
            value.isEmpty ? 'Not added' : value,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            softWrap: true,
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                const SizedBox(height: 2),
                valueWidget,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: labelWidget,
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: valueWidget,
              ),
            ],
          );
        },
      ),
    );
  }
}
