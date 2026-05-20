import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/constants/auth_endpoints.dart';
import '../dto/auth_login_response_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/signup_request_dto.dart';
import '../dto/profile_response_dto.dart';

class AuthApiService {
  final Dio dio;
  AuthApiService(this.dio);

  Future<AuthLoginResponseDto> login(LoginRequestDto dto) async {
    final res = await dio.post(AuthEndpoints.login, data: dto.toJson());
    return AuthLoginResponseDto.fromJson(_asMap(res.data));
  }

  Future<AuthLoginResponseDto> registerUser(SignupRequestDto dto) async {
    final res = await dio.post(AuthEndpoints.registerUser, data: dto.toJson());
    return AuthLoginResponseDto.fromJson(_asMap(res.data));
  }

  Future<String> forgotPassword(String email) async {
    final res = await dio.post(
      AuthEndpoints.forgotPassword,
      data: <String, dynamic>{'email': email},
    );
    return _extractMessage(res.data, fallback: 'Password reset link sent.');
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final res = await dio.post(
      AuthEndpoints.resetPassword,
      data: <String, dynamic>{'token': token, 'newPassword': newPassword},
    );
    return _extractMessage(res.data, fallback: 'Password reset successful.');
  }

  Future<String> verifyEmail(String token) async {
    final res = await dio.get(
      AuthEndpoints.verifyEmail,
      queryParameters: <String, dynamic>{'token': token},
    );
    return _extractMessage(
      res.data,
      fallback: 'Email verification completed.',
    );
  }

  Future<String> sendTestEmail() async {
    final res = await dio.get(AuthEndpoints.testEmail);
    return _extractMessage(
      res.data,
      fallback: 'Verification email request submitted.',
    );
  }

  Future<ProfileResponseDto> me() async {
    final res = await dio.get('/api/users/profile');
    return ProfileResponseDto.fromJson(_asMap(res.data));
  }
}

Map<String, dynamic> _asMap(Object? raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return <String, dynamic>{};
}

String _extractMessage(Object? raw, {required String fallback}) {
  if (raw == null) return fallback;
  if (raw is String) {
    final text = raw.trim();
    return text.isEmpty ? fallback : text;
  }
  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);
    final message = map['message'] ?? map['msg'] ?? map['error'];
    final text = message?.toString().trim();
    if (text != null && text.isNotEmpty) return text;
  }
  return fallback;
}
