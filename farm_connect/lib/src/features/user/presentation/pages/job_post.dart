import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/features/jobs/application/job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobPostPage extends ConsumerStatefulWidget {
  const JobPostPage({super.key});

  @override
  ConsumerState<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends ConsumerState<JobPostPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final wageController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    wageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(createJobControllerProvider);

    return Scaffold(
      appBar: appTopBar(title: const Text('Post Job')),
      body: AppScreen(
        child: ResponsiveForm(
          formKey: _formKey,
          children: [
            AppSurface(
              featured: true,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Job Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    controller: titleController,
                    label: 'Work Title',
                    hint: 'Harvesting job',
                    prefixIcon: Icons.work_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Work title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    controller: locationController,
                    label: 'Location',
                    hint: 'Village or district',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    controller: wageController,
                    label: 'Wage',
                    hint: '500 per day',
                    prefixIcon: Icons.currency_rupee_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    controller: descriptionController,
                    label: 'Description',
                    hint: 'Add job details',
                    prefixIcon: Icons.notes_outlined,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            PrimaryButton(
              text: 'SAVE JOB',
              isLoading: submitState.isLoading,
              trailingIcon: Icons.check_rounded,
              onPressed: submitState.isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final wage = num.tryParse(wageController.text.trim());
    await ref.read(createJobControllerProvider.notifier).create(
          title: titleController.text.trim(),
          location: locationController.text.trim(),
          wage: wage,
          description: descriptionController.text.trim(),
        );

    final state = ref.read(createJobControllerProvider);
    if (!mounted) return;
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMessageForJobError(state.error!)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job saved successfully.')),
    );
    context.pop();
  }
}
