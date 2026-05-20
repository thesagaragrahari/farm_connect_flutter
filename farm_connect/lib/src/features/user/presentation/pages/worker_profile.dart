import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/profile_header.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/section_heading.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/work_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),

            const SectionHeading(title: 'Skills'),
            const WorkerInfoTile(
              value: 'Harvesting, Tractor Handling, Irrigation',
            ),

            const SizedBox(height: 20),

            const SectionHeading(title: 'Experience'),
            const WorkerInfoTile(value: '5 Years'),

            const SizedBox(height: 20),

            const SectionHeading(title: 'Past Work Summary'),
            const WorkerInfoTile(
              value:
                  'Worked on multiple farms for harvesting and crop maintenance.',
            ),

            const SizedBox(height: 30),

            PrimaryButton(
              text: 'HIRE WORKER',
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: () => context.push('/post-job'),
            ),
          ],
        ),
      ),
    );
  }
}