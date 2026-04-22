// i_auth_repository.dart
import '../entities/auth_session.dart';
import '../entities/user_profile.dart';

abstract class IAuthRepository {
  Future<AuthSession> login(String email, String password, String role);
  Future<String> signup(String name, String email, String password, String role);
  Future<String> forgotPassword(String email);
  Future<String> resetPassword({required String token, required String newPassword});
  Future<String> verifyEmail(String token);
  Future<String> resendVerificationEmail();
  Future<void> logout();
  Future<UserProfile> loadProfile();
}
