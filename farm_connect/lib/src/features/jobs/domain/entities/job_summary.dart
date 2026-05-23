class JobSummary {
  final String id;
  final String title;
  final String? description;
  final String? location;
  final String? status;
  final String? assignedWorkerName;
  final num? wage;
  final DateTime? startsAt;

  const JobSummary({
    required this.id,
    required this.title,
    this.description,
    this.location,
    this.status,
    this.assignedWorkerName,
    this.wage,
    this.startsAt,
  });
}
