class LoginResponseDto {
  final String token;
  final bool profileCompleted;

  LoginResponseDto({
    required this.token,
    required this.profileCompleted,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String,
      profileCompleted: json['profileCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'profileCompleted': profileCompleted,
      };
}
