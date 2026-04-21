// i_auth_repository.dart
import '../entities/auth_session.dart';
import '../entities/user_profile.dart';

abstract class IAuthRepository {
  Future<AuthSession> login(String email, String password,String role); // role: worker/farmer
  Future<AuthSession> signup(String name, String email, String password, String role); // role: worker/farmer
  Future<void> logout();
  Future<UserProfile> loadProfile();
}