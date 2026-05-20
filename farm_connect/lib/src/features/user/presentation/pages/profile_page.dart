import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 42,
              child: Icon(Icons.person_outline_rounded, size: 42),
            ),

            const SizedBox(height: 30),

            const CustomTextField(
              label: 'Name',
              hint: 'Enter full name',
            ),

            const SizedBox(height: 16),

            const CustomTextField(
              label: 'Location',
              hint: 'Enter location',
            ),

            const SizedBox(height: 16),

            const CustomTextField(
              label: 'Mobile Number',
              hint: 'Enter mobile number',
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            const CustomTextField(
              label: 'Email',
              hint: 'Enter email',
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 28),

            PrimaryButton(
              text: 'SAVE CHANGES',
              trailingIcon: Icons.save_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}