class ProfileResponseDto {
  final String fullName;
  final String email;
  final String? phone;
  final String? role;

  ProfileResponseDto({
    required this.fullName,
    required this.email,
    this.phone,
    this.role,
  });

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileResponseDto(
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: json['phone']?.toString(),
      role: json['role']?.toString(),
    );
  }
}
