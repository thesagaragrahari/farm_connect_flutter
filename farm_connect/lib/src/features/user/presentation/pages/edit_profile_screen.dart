import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final bioController = TextEditingController();
  final languageController = TextEditingController();
  bool _filled = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    addressController.dispose();
    bioController.dispose();
    languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        ),
      );
    });

    final state = ref.watch(userControllerProvider);
    final userState = state.value;
    final profile = userState?.profile;
    if (profile != null && !_filled) {
      _filled = true;
      nameController.text = profile.fullName;
      phoneController.text = profile.phone ?? '';
      locationController.text = profile.location ?? '';
      addressController.text = profile.address ?? '';
      bioController.text = profile.bio ?? '';
      languageController.text = profile.language ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: state.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      child: Icon(Icons.person_outline_rounded, size: 42),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      label: 'Name',
                      hint: 'Enter full name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: phoneController,
                      label: 'Mobile Number',
                      hint: 'Enter mobile number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: locationController,
                      label: 'Location',
                      hint: 'Enter location',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: addressController,
                      label: 'Address',
                      hint: 'Village, district, state',
                      prefixIcon: Icons.home_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: languageController,
                      label: 'Language',
                      hint: 'Hindi, English',
                      prefixIcon: Icons.translate_outlined,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: bioController,
                      label: 'Bio',
                      hint: 'Tell people about your work',
                      prefixIcon: Icons.notes_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'SAVE CHANGES',
                      isLoading: userState?.isSaving ?? false,
                      trailingIcon: Icons.save_outlined,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(userControllerProvider.notifier).updateProfile(
          fullName: nameController.text.trim(),
          phone: phoneController.text.trim(),
          location: locationController.text.trim(),
          address: addressController.text.trim(),
          bio: bioController.text.trim(),
          language: languageController.text.trim(),
        );
    if (mounted && ref.read(userControllerProvider).hasValue) {
      context.pop();
    }
  }
}
