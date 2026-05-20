import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/user_card.dart';
import 'package:flutter/material.dart';

class ActiveUsersPage extends StatelessWidget {
  const ActiveUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Users'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Worker'),
              Tab(text: 'Operator'),
              Tab(text: 'Owner'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CustomTextField(
                label: 'Search',
                hint: 'Search workers...',
                prefixIcon: Icons.search_rounded,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Skill'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Location'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Rating'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, index) {
                    return const UserCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}