import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'skill_selection_screen.dart';
import 'widgets/skill_chip_picker.dart';

class WorkerDetailsScreen extends ConsumerStatefulWidget {
  const WorkerDetailsScreen({super.key});

  @override
  ConsumerState<WorkerDetailsScreen> createState() =>
      _WorkerDetailsScreenState();
}

class _WorkerDetailsScreenState extends ConsumerState<WorkerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final experienceController = TextEditingController();
  final wageController = TextEditingController();
  final workTypeController = TextEditingController();
  final radiusController = TextEditingController();
  final locationController = TextEditingController();
  final historyController = TextEditingController();
  final skills = <String>[];
  bool isAvailable = true;
  bool _filled = false;

  @override
  void dispose() {
    experienceController.dispose();
    wageController.dispose();
    workTypeController.dispose();
    radiusController.dispose();
    locationController.dispose();
    historyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(userControllerProvider);
    final userState = asyncState.value;
    final worker = userState?.profile?.workerProfile;
    if (worker != null && !_filled) {
      _filled = true;
      skills.addAll(worker.skills);
      experienceController.text = worker.experience ?? '';
      wageController.text = worker.expectedWage?.toString() ?? '';
      workTypeController.text = worker.preferredWorkType ?? '';
      radiusController.text = worker.workRadius ?? '';
      locationController.text = worker.workLocation ?? '';
      historyController.text = worker.previousWorkHistory.join(', ');
      isAvailable = worker.isAvailable;
    }

    return Scaffold(
      appBar: appTopBar(title: const Text('Worker Details')),
      body: ResponsiveForm(
        formKey: _formKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Skills',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: _selectSkills,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Edit'),
              ),
            ],
          ),
          SkillChipPicker(
            skills: skills.isEmpty ? kFarmSkills.take(4).toList() : skills,
            selectedSkills: skills,
            onChanged: (_) {},
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Available for work'),
            value: isAvailable,
            onChanged: (value) => setState(() => isAvailable = value),
          ),
          _WorkerFieldGrid(
            experienceController: experienceController,
            wageController: wageController,
            workTypeController: workTypeController,
            radiusController: radiusController,
            locationController: locationController,
            historyController: historyController,
          ),
          PrimaryButton(
            text: 'SAVE WORKER DETAILS',
            isLoading: userState?.isSaving ?? false,
            trailingIcon: Icons.save_outlined,
            onPressed: _save,
          ),
        ],
      ),
    );
  }

  Future<void> _selectSkills() async {
    final result = await context.push<List<String>>(AppRoutes.workerSkills);
    if (result == null) return;
    setState(() {
      skills
        ..clear()
        ..addAll(result);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill.')),
      );
      return;
    }
    await ref.read(userControllerProvider.notifier).updateWorkerProfile(
          skills: skills,
          experience: experienceController.text.trim(),
          isAvailable: isAvailable,
          expectedWage: num.tryParse(wageController.text.trim()),
          preferredWorkType: workTypeController.text.trim(),
          workRadius: radiusController.text.trim(),
          workLocation: locationController.text.trim(),
          previousWorkHistory: _splitValues(historyController.text),
        );
    if (mounted && ref.read(userControllerProvider).hasValue) context.pop();
  }
}

class _WorkerFieldGrid extends StatelessWidget {
  final TextEditingController experienceController;
  final TextEditingController wageController;
  final TextEditingController workTypeController;
  final TextEditingController radiusController;
  final TextEditingController locationController;
  final TextEditingController historyController;

  const _WorkerFieldGrid({
    required this.experienceController,
    required this.wageController,
    required this.workTypeController,
    required this.radiusController,
    required this.locationController,
    required this.historyController,
  });

  @override
  Widget build(BuildContext context) {
    final fields = [
      CustomTextField(
        controller: experienceController,
        label: 'Experience',
        hint: '5 years',
        prefixIcon: Icons.timeline_outlined,
      ),
      CustomTextField(
        controller: wageController,
        label: 'Expected Wage',
        hint: '500',
        prefixIcon: Icons.currency_rupee_rounded,
        keyboardType: TextInputType.number,
      ),
      CustomTextField(
        controller: workTypeController,
        label: 'Preferred Work Type',
        hint: 'Daily, seasonal, contract',
        prefixIcon: Icons.work_outline_rounded,
      ),
      CustomTextField(
        controller: radiusController,
        label: 'Work Radius',
        hint: '10 km',
        prefixIcon: Icons.radar_outlined,
      ),
      CustomTextField(
        controller: locationController,
        label: 'Work Location',
        hint: 'Preferred village or district',
        prefixIcon: Icons.location_on_outlined,
      ),
      CustomTextField(
        controller: historyController,
        label: 'Previous Work History',
        hint: 'Harvesting wheat, irrigation support',
        prefixIcon: Icons.history_outlined,
        maxLines: 3,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            children: [
              for (var i = 0; i < fields.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.lg),
                fields[i],
              ],
            ],
          );
        }

        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: fields
              .map(
                (field) => SizedBox(
                  width: (constraints.maxWidth - AppSpacing.lg) / 2,
                  child: field,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

List<String> _splitValues(String value) {
  return value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
