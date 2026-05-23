import 'package:farm_connect/src/features/user/presentation/pages/widgets/job_card.dart';
import 'package:flutter/material.dart';

class ManageJobsPage extends StatelessWidget {
  const ManageJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Jobs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Past'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJobs(),
            _buildJobs(),
            _buildJobs(),
          ],
        ),
      ),
    );
  }

  Widget _buildJobs() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => const JobCard(),
    );
  }
}
