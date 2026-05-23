import 'package:farm_connect/src/core/common_widgets/custom_text_field.dart';
import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/features/user/application/user_controller.dart';
import 'package:farm_connect/src/features/user/domain/entities/user_profile_details.dart';
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
        appBar: appTopBar(
          title: const Text('Active Users'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Workers'),
            ],
          ),
        ),
        body: AppScreen(
          child: ResponsivePage(
            maxWidth: ResponsiveLayout.dashboardMaxWidth(context),
            scrollable: false,
            child: Column(
              children: [
                _WorkerFilters(
                  skillController: skillController,
                  locationController: locationController,
                  onApply: _applyFilters,
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: _WorkerResults(
                    isLoading: userState.isLoading,
                    workers: workers,
                    hasMore: userState.value?.hasMoreWorkers ?? false,
                    onLoadMore: _loadMore,
                  ),
                ),
              ],
            ),
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

class _WorkerFilters extends StatelessWidget {
  final TextEditingController skillController;
  final TextEditingController locationController;
  final VoidCallback onApply;

  const _WorkerFilters({
    required this.skillController,
    required this.locationController,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      featured: true,
      padding: EdgeInsets.all(
        ResponsiveLayout.isMobile(context) ? AppSpacing.lg : AppSpacing.xl,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final fields = [
            CustomTextField(
              controller: skillController,
              label: 'Skill',
              hint: 'Harvesting, irrigation...',
              prefixIcon: Icons.handyman_outlined,
            ),
            CustomTextField(
              controller: locationController,
              label: 'Location',
              hint: 'Village or district',
              prefixIcon: Icons.location_on_outlined,
            ),
            OutlinedButton.icon(
              onPressed: onApply,
              icon: const Icon(Icons.filter_alt_outlined),
              label: const Text('Apply filters'),
            ),
          ];

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fields[0],
                const SizedBox(height: AppSpacing.lg),
                fields[1],
                const SizedBox(height: AppSpacing.lg),
                fields[2],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: fields[0]),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: fields[1]),
              const SizedBox(width: AppSpacing.lg),
              Flexible(child: fields[2]),
            ],
          );
        },
      ),
    );
  }
}

class _WorkerResults extends StatelessWidget {
  final bool isLoading;
  final List<UserProfileDetails> workers;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const _WorkerResults({
    required this.isLoading,
    required this.workers,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && workers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (workers.isEmpty) {
      return const Center(child: Text('No available workers found.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final grid = constraints.maxWidth >= 720;

        if (grid) {
          return SingleChildScrollView(
            child: ResponsiveGrid(
              minChildWidth: 320,
              children: [
                ...workers.map((user) => UserCard(user: user)),
                if (hasMore)
                  OutlinedButton(
                    onPressed: onLoadMore,
                    child: const Text('Load more'),
                  ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: workers.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, index) {
            if (index == workers.length) {
              return hasMore
                  ? OutlinedButton(
                      onPressed: onLoadMore,
                      child: const Text('Load more'),
                    )
                  : const SizedBox.shrink();
            }
            return UserCard(user: workers[index]);
          },
        );
      },
    );
  }
}
