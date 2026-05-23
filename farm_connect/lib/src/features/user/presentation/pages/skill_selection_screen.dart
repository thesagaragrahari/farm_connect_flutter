import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/skill_chip_picker.dart';

const List<String> kFarmSkills = [
  'Harvesting',
  'Sowing',
  'Irrigation',
  'Tractor Handling',
  'Crop Cutting',
  'Spraying',
  'Dairy Work',
  'Packing',
  'Farm Maintenance',
  'Organic Farming',
];

class SkillSelectionScreen extends ConsumerStatefulWidget {
  const SkillSelectionScreen({super.key});

  @override
  ConsumerState<SkillSelectionScreen> createState() =>
      _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends ConsumerState<SkillSelectionScreen> {
  final selectedSkills = <String>[];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userControllerProvider).value;
    final existing = state?.profile?.workerProfile?.skills ?? const [];
    if (selectedSkills.isEmpty && existing.isNotEmpty) {
      selectedSkills.addAll(existing);
    }

    return Scaffold(
      appBar: appTopBar(title: const Text('Select Skills')),
      body: ResponsivePage(
        scrollable: false,
        maxWidth: ResponsiveLayout.formMaxWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the farm work you can do',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            SkillChipPicker(
              skills: kFarmSkills,
              selectedSkills: selectedSkills,
              onChanged: (skill) {
                setState(() {
                  selectedSkills.contains(skill)
                      ? selectedSkills.remove(skill)
                      : selectedSkills.add(skill);
                });
              },
            ),
            const Spacer(),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'SAVE SKILLS',
              trailingIcon: Icons.check_rounded,
              onPressed: selectedSkills.isEmpty
                  ? null
                  : () {
                      context
                          .pop<List<String>>(List<String>.from(selectedSkills));
                    },
            ),
          ],
        ),
      ),
    );
  }
}
