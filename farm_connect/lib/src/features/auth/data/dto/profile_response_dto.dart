class ProfileResponseDto {
  final String name;
  final String email;
  ProfileResponseDto({required this.name, required this.email});
  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      ProfileResponseDto(name: json['name'], email: json['email']);
}