class AuthLoginResponseDto {
  final bool success;
  final String message;
  final String? token;
  final AuthLoginDataDto? data;

  const AuthLoginResponseDto({
    required this.success,
    required this.message,
    this.token,
    this.data,
  });

  String? get resolvedToken => data?.token ?? token;

  factory AuthLoginResponseDto.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final dataMap = rawData is Map ? Map<String, dynamic>.from(rawData) : null;

    return AuthLoginResponseDto(
      success: json['success'] is bool ? json['success'] as bool : true,
      message: (json['message'] ?? json['msg'] ?? '').toString(),
      token: _stringOrNull(json['token']),
      data: dataMap != null ? AuthLoginDataDto.fromJson(dataMap) : null,
    );
  }
}

class AuthLoginDataDto {
  final String? token;
  final bool? profileCompleted;
  final AuthUserProfileDto? userProfile;

  const AuthLoginDataDto({
    this.token,
    this.profileCompleted,
    this.userProfile,
  });

  factory AuthLoginDataDto.fromJson(Map<String, dynamic> json) {
    final rawProfile = json['userProfile'];
    final userProfileMap =
        rawProfile is Map ? Map<String, dynamic>.from(rawProfile) : null;

    return AuthLoginDataDto(
      token: _stringOrNull(json['token']),
      profileCompleted: json['profileCompleted'] is bool
          ? json['profileCompleted'] as bool
          : null,
      userProfile: userProfileMap != null
          ? AuthUserProfileDto.fromJson(userProfileMap)
          : null,
    );
  }
}

class AuthUserProfileDto {
  final String fullName;
  final String email;
  final String? role;

  const AuthUserProfileDto({
    required this.fullName,
    required this.email,
    this.role,
  });

  factory AuthUserProfileDto.fromJson(Map<String, dynamic> json) {
    return AuthUserProfileDto(
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: _stringOrNull(json['role']),
    );
  }
}

String? _stringOrNull(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
