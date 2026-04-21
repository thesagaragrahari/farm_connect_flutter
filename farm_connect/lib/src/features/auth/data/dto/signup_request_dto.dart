class SignupRequestDto {
  final String name;
  final String email;
  final String password;
  final String role; // worker/farmer
  SignupRequestDto({required this.name, required this.email, required this.password, required this.role});
  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'password': password};
}