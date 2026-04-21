import 'package:farm_connect/src/core/storage/secure_storage.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../sources/auth_api_service.dart';
import 'package:hive/hive.dart';
import '../dto/login_request_dto.dart';
import '../dto/signup_request_dto.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthApiService apiService;
  final SecureStorage storage;

  AuthRepositoryImpl({required this.apiService, required this.storage});

  @override
  Future<AuthSession> login(String email, String password,String role) async {
    final dto = LoginRequestDto(email: email, password: password,role: role);
    final res = await apiService.login(dto);
    await storage.writeToken(res.token);
    return AuthSession(token: res.token);
  }

  @override
  Future<AuthSession> signup(String name, String email, String password, String role) async {
    final dto = SignupRequestDto(name: name, email: email, password: password, role: role);
    final res = await apiService.signup(dto);
    await storage.writeToken(res.token);
    return AuthSession(token: res.token);
  }

  @override
  Future<void> logout() async {
    await storage.clear();
    final box = Hive.box<UserProfile>('user_profile');
    await box.clear();
  }

  @override
  Future<UserProfile> loadProfile() async {
    try {
      final res = await apiService.me();
      final profile = UserProfile(name: res.name, email: res.email);
      await Hive.box<UserProfile>('user_profile').put('me', profile);
      return profile;
    } catch (_) {
      return Hive.box<UserProfile>('user_profile').get('me')!;
    }
  }
}