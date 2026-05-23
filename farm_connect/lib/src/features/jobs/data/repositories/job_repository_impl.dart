import '../../domain/entities/job_summary.dart';
import '../dto/create_job_request_dto.dart';
import '../sources/job_api_service.dart';

class JobRepositoryImpl {
  final JobApiService apiService;

  const JobRepositoryImpl({required this.apiService});

  Future<List<JobSummary>> listJobs({String? status}) async {
    final jobs = await apiService.listJobs(status: status);
    return jobs.map((job) => job.toEntity()).toList(growable: false);
  }

  Future<JobSummary> createJob({
    required String title,
    String? location,
    num? wage,
    String? description,
  }) async {
    final dto = CreateJobRequestDto(
      title: title,
      location: location,
      wage: wage,
      description: description,
    );
    return (await apiService.createJob(dto)).toEntity();
  }

  Future<JobSummary> publicJob(String id) async {
    return (await apiService.publicJob(id)).toEntity();
  }
}
