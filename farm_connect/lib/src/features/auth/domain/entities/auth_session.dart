// auth_session.dart
class AuthSession {
  final String token;
  final String? role;

  const AuthSession({
    required this.token,
    this.role,
  });
}
