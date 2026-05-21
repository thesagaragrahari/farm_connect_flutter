import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:farm_connect/src/features/user/presentation/pages/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveUsersPage extends ConsumerStatefulWidget {
  const ActiveUsersPage({super.key});

  @override
  ConsumerState<ActiveUsersPage> createState() => _ActiveUsersPageState();
}

class _ActiveUsersPageState extends ConsumerState<ActiveUsersPage> {
  final skillController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userControllerProvider.notifier).loadWorkers(reset: true);
    });
  }

  @override
  void dispose() {
    skillController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);
    final workers = userState.value?.workers ?? const [];

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Users'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Workers'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextField(
                controller: skillController,
                label: 'Skill',
                hint: 'Harvesting, irrigation...',
                prefixIcon: Icons.handyman_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: locationController,
                label: 'Location',
                hint: 'Village or district',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _applyFilters,
                icon: const Icon(Icons.filter_alt_outlined),
                label: const Text('Apply filters'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: userState.isLoading && workers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : workers.isEmpty
                        ? const Center(
                            child: Text('No available workers found.'),
                          )
                        : ListView.separated(
                            itemCount: workers.length + 1,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (_, index) {
                              if (index == workers.length) {
                                final hasMore =
                                    userState.value?.hasMoreWorkers ?? false;
                                return hasMore
                                    ? OutlinedButton(
                                        onPressed: _loadMore,
                                        child: const Text('Load more'),
                                      )
                                    : const SizedBox.shrink();
                              }
                              return UserCard(user: workers[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    ref.read(userControllerProvider.notifier).loadWorkers(
          skill: skillController.text.trim(),
          location: locationController.text.trim(),
          reset: true,
        );
  }

  void _loadMore() {
    ref.read(userControllerProvider.notifier).loadWorkers(
          skill: skillController.text.trim(),
          location: locationController.text.trim(),
        );
  }
}
