import 'package:flutter/material.dart';

import 'package:farm_connect/src/core/theme/app_theme.dart';

class WorkerInfoTile extends StatelessWidget {
  final String value;

  const WorkerInfoTile({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(context),
      child: Text(
        value,
        style: TextStyle(
          color: AppTheme.appText(context),
        ),
      ),
    );
  }
}
