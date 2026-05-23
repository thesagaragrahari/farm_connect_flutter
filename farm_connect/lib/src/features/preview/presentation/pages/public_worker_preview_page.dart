import 'package:farm_connect/src/features/user/presentation/pages/public_profile_screen.dart';
import 'package:flutter/material.dart';

class PublicWorkerPreviewPage extends StatelessWidget {
  final String workerId;

  const PublicWorkerPreviewPage({
    super.key,
    required this.workerId,
  });

  @override
  Widget build(BuildContext context) {
    return PublicProfileScreen(userId: workerId);
  }
}
