import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/constants/job_endpoints.dart';

import '../dto/create_job_request_dto.dart';
import '../dto/job_summary_dto.dart';

class JobApiService {
  final Dio dio;

  const JobApiService(this.dio);

  Future<List<JobSummaryDto>> listJobs({String? status}) async {
    final res = await dio.get(
      JobEndpoints.myJobs,
      queryParameters: <String, dynamic>{
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    return _jobList(res.data);
  }

  Future<JobSummaryDto> createJob(CreateJobRequestDto dto) async {
    final res = await dio.post(JobEndpoints.jobs, data: dto.toJson());
    return JobSummaryDto.fromJson(_jobMap(res.data));
  }

  Future<JobSummaryDto> publicJob(String id) async {
    final res = await dio.get(JobEndpoints.publicJob(id));
    return JobSummaryDto.fromJson(_jobMap(res.data));
  }
}

List<JobSummaryDto> _jobList(Object? raw) {
  final map = _asMap(raw);
  final data = map['data'];
  final jobs = data is Map ? data['jobs'] : data;
  final list = jobs is List ? jobs : map['jobs'];
  if (list is! List) return const [];

  return list
      .whereType<Map>()
      .map((item) => JobSummaryDto.fromJson(Map<String, dynamic>.from(item)))
      .where((job) => job.id.isNotEmpty && job.title.isNotEmpty)
      .toList(growable: false);
}

Map<String, dynamic> _jobMap(Object? raw) {
  final map = _asMap(raw);
  final data = map['data'];
  if (data is Map) {
    final nestedJob = data['job'];
    if (nestedJob is Map) return Map<String, dynamic>.from(nestedJob);
    return Map<String, dynamic>.from(data);
  }
  final job = map['job'];
  if (job is Map) return Map<String, dynamic>.from(job);
  return map;
}

Map<String, dynamic> _asMap(Object? raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return <String, dynamic>{};
}
