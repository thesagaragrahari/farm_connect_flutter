import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmerDetailsScreen extends ConsumerStatefulWidget {
  const FarmerDetailsScreen({super.key});

  @override
  ConsumerState<FarmerDetailsScreen> createState() => _FarmerDetailsScreenState();
}

class _FarmerDetailsScreenState extends ConsumerState<FarmerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final farmTypeController = TextEditingController();
  final landSizeController = TextEditingController();
  final categoryController = TextEditingController();
  final hiringController = TextEditingController();
  bool _filled = false;

  @override
  void dispose() {
    farmTypeController.dispose();
    landSizeController.dispose();
    categoryController.dispose();
    hiringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider).value;
    final farmer = userState?.profile?.farmerProfile;
    if (farmer != null && !_filled) {
      _filled = true;
      farmTypeController.text = farmer.farmType ?? '';
      landSizeController.text = farmer.landSize ?? '';
      categoryController.text = farmer.farmingCategory ?? '';
      hiringController.text = farmer.seasonalHiringPreferences.join(', ');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: farmTypeController,
                label: 'Farm Type',
                hint: 'Own farm, leased farm',
                prefixIcon: Icons.agriculture_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: landSizeController,
                label: 'Land Size',
                hint: '5 acres',
                prefixIcon: Icons.landscape_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: categoryController,
                label: 'Farming Category',
                hint: 'Wheat, paddy, vegetables',
                prefixIcon: Icons.grass_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: hiringController,
                label: 'Seasonal Hiring Preferences',
                hint: 'Harvesting, sowing, spraying',
                prefixIcon: Icons.people_alt_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: 'SAVE FARMER DETAILS',
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
    await ref.read(userControllerProvider.notifier).updateFarmerProfile(
          farmType: farmTypeController.text.trim(),
          landSize: landSizeController.text.trim(),
          farmingCategory: categoryController.text.trim(),
          seasonalHiringPreferences: _splitValues(hiringController.text),
        );
    if (mounted && ref.read(userControllerProvider).hasValue) context.pop();
  }
}

List<String> _splitValues(String value) {
  return value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
