import 'package:dio/dio.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/job_repository_impl.dart';
import '../data/sources/job_api_service.dart';
import '../domain/entities/job_summary.dart';

final jobRepositoryProvider = Provider<JobRepositoryImpl>((ref) {
  final dio = ref.watch(dioProvider);
  return JobRepositoryImpl(apiService: JobApiService(dio));
});

final jobsProvider =
    FutureProvider.family<List<JobSummary>, String?>((ref, status) {
  return ref.watch(jobRepositoryProvider).listJobs(status: status);
});

final publicJobProvider = FutureProvider.family<JobSummary, String>((ref, id) {
  if (id.trim().isEmpty) throw ArgumentError('Invalid public job link.');
  return ref.watch(jobRepositoryProvider).publicJob(id);
});

final createJobControllerProvider =
    AsyncNotifierProvider<CreateJobController, void>(CreateJobController.new);

class CreateJobController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> create({
    required String title,
    String? location,
    num? wage,
    String? description,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(jobRepositoryProvider).createJob(
            title: title,
            location: location,
            wage: wage,
            description: description,
          );
    });
  }
}

String userMessageForJobError(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'Unable to complete the job request. Please try again.';
  }
  return error.toString();
}
