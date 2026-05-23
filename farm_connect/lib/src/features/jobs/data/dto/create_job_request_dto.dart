class CreateJobRequestDto {
  final String title;
  final String? location;
  final num? wage;
  final String? description;

  const CreateJobRequestDto({
    required this.title,
    this.location,
    this.wage,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      if (location != null && location!.isNotEmpty) 'location': location,
      if (wage != null) 'wage': wage,
      if (description != null && description!.isNotEmpty)
        'description': description,
    };
  }
}
