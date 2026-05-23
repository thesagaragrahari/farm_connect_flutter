import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/env/app_config.dart';
import 'package:farm_connect/src/core/network/interceptors/redacting_log_interceptors.dart';
import 'package:farm_connect/src/core/storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/sources/auth_api_service.dart';
import '../domain/entities/auth_session.dart';
import '../domain/entities/user_profile.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.backendUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(RedactingLogInterceptor());
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.readToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  return dio;
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final dio = ref.watch(dioProvider);
  final apiService = AuthApiService(dio);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(apiService: apiService, storage: storage);
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  late AuthRepositoryImpl _repository;

  @override
  Future<AuthSession?> build() async {
    _repository = ref.watch(authRepositoryProvider);
    final token = await _repository.storage.readToken();
    if (token != null && token.isNotEmpty) {
      final role = await _repository.storage.readRole();
      return AuthSession(token: token, role: role);
    }
    return null;
  }

  Future<void> login(String email, String password, String role) async {
    state = const AsyncLoading();
    try {
      final session = await _repository.login(email, password, role);
      state = AsyncData(session);
    } on DioException catch (e, stackTrace) {
      state = AsyncError(
          _extractDioMessage(e, fallback: 'Login failed'), stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e.toString(), stackTrace);
    }
  }

  Future<String> signup(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      return await _repository.signup(name, email, password, role);
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e, fallback: 'Signup failed'));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      return await _repository.forgotPassword(email);
    } on DioException catch (e) {
      throw Exception(
          _extractDioMessage(e, fallback: 'Failed to send reset link'));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _repository.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e, fallback: 'Password reset failed'));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> verifyEmail(String token) async {
    try {
      return await _repository.verifyEmail(token);
    } on DioException catch (e) {
      throw Exception(
          _extractDioMessage(e, fallback: 'Email verification failed'));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> resendVerification([String? email]) async {
    try {
      return await _repository.resendVerificationEmail();
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e,
          fallback: 'Failed to resend verification email'));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await _repository.logout();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e.toString(), stackTrace);
    }
  }

  Future<UserProfile> loadProfile() async {
    return _repository.loadProfile();
  }
}

String _extractDioMessage(DioException e, {required String fallback}) {
  final payload = e.response?.data;
  if (payload == null) return fallback;

  if (payload is String) {
    final text = payload.trim();
    return text.isEmpty ? fallback : text;
  }

  if (payload is Map) {
    final map = Map<String, dynamic>.from(payload);
    final message = map['message'] ?? map['msg'] ?? map['error'];
    if (message != null) {
      final text = message.toString().trim();
      if (text.isNotEmpty) return text;
    }
  }

  return fallback;
}
