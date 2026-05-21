class WorkerProfileRequestDto {
  final List<String> skills;
  final String? experience;
  final bool isAvailable;
  final num? expectedWage;
  final String? preferredWorkType;
  final String? workRadius;
  final String? workLocation;
  final List<String> previousWorkHistory;

  const WorkerProfileRequestDto({
    required this.skills,
    this.experience,
    required this.isAvailable,
    this.expectedWage,
    this.preferredWorkType,
    this.workRadius,
    this.workLocation,
    required this.previousWorkHistory,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'skills': skills,
      if (_hasValue(experience)) 'experience': experience,
      'availabilityStatus': isAvailable,
      if (expectedWage != null) 'expectedWage': expectedWage,
      if (_hasValue(preferredWorkType)) 'preferredWorkType': preferredWorkType,
      if (_hasValue(workRadius)) 'workRadius': workRadius,
      if (_hasValue(workLocation)) 'workLocation': workLocation,
      'previousWorkHistory': previousWorkHistory,
    };
  }
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
