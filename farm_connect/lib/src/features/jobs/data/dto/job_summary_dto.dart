import '../../domain/entities/job_summary.dart';

class JobSummaryDto {
  final String id;
  final String title;
  final String? description;
  final String? location;
  final String? status;
  final String? assignedWorkerName;
  final num? wage;
  final DateTime? startsAt;

  const JobSummaryDto({
    required this.id,
    required this.title,
    this.description,
    this.location,
    this.status,
    this.assignedWorkerName,
    this.wage,
    this.startsAt,
  });

  factory JobSummaryDto.fromJson(Map<String, dynamic> json) {
    return JobSummaryDto(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title:
          (json['title'] ?? json['workTitle'] ?? json['name'] ?? '').toString(),
      description: _stringOrNull(json['description']),
      location: _stringOrNull(json['location']),
      status: _stringOrNull(json['status']),
      assignedWorkerName: _stringOrNull(
        json['assignedWorkerName'] ?? json['workerName'],
      ),
      wage: json['wage'] is num ? json['wage'] as num : null,
      startsAt: DateTime.tryParse((json['startsAt'] ?? '').toString()),
    );
  }

  JobSummary toEntity() {
    return JobSummary(
      id: id,
      title: title,
      description: description,
      location: location,
      status: status,
      assignedWorkerName: assignedWorkerName,
      wage: wage,
      startsAt: startsAt,
    );
  }
}

String? _stringOrNull(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
