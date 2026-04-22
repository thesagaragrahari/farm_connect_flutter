import 'package:farm_connect/src/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
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
  Future<AuthSession> login(String email, String password, String role) async {
    final dto = LoginRequestDto(email: email, password: password, role: role);
    final res = await apiService.login(dto);
    final token = res.resolvedToken;
    if (token == null || token.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        error: res.message.isEmpty ? 'Token missing in login response.' : res.message,
      );
    }

    await storage.writeToken(token);
    return AuthSession(token: token);
  }

  @override
  Future<String> signup(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final dto = SignupRequestDto(name: name, email: email, password: password, role: role);
    final res = await apiService.registerUser(dto);

    final token = res.resolvedToken;
    if (token != null && token.isNotEmpty) {
      await storage.writeToken(token);
    }

    if (res.message.isNotEmpty) return res.message;
    return token != null
        ? 'Registration successful.'
        : 'Registration successful. Please verify your email.';
  }

  @override
  Future<String> forgotPassword(String email) {
    return apiService.forgotPassword(email);
  }

  @override
  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) {
    return apiService.resetPassword(token: token, newPassword: newPassword);
  }

  @override
  Future<String> verifyEmail(String token) {
    return apiService.verifyEmail(token);
  }

  @override
  Future<String> resendVerificationEmail() {
    return apiService.sendTestEmail();
  }

  @override
  Future<void> logout() async {
    await storage.clear();
    final box = Hive.box<UserProfile>('user_profile');
    await box.clear();
  }

  @override
  Future<UserProfile> loadProfile() async {
    final box = Hive.box<UserProfile>('user_profile');
    try {
      final res = await apiService.me();
      final profile = UserProfile(name: res.fullName, email: res.email);
      await box.put('me', profile);
      return profile;
    } catch (_) {
      final cached = box.get('me');
      if (cached != null) return cached;
      rethrow;
    }
  }
}
