import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobPostPage extends StatefulWidget {
  const JobPostPage({super.key});

  @override
  State<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Post Job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: locationController,
                label: 'Location',
                hint: 'Village or district',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: wageController,
                label: 'Wage',
                hint: '500 per day',
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                label: 'Description',
                hint: 'Add job details',
                prefixIcon: Icons.notes_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: 'SAVE JOB',
                trailingIcon: Icons.check_rounded,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job draft saved locally.')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
