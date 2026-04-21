import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/storage/secure_storage.dart';
import 'package:farm_connect/src/core/env/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/sources/auth_api_service.dart';
import '../domain/entities/auth_session.dart';
import '../domain/entities/user_profile.dart';


// Dio provider (you can move this to a separate file later)
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.backendUrl, // ← CHANGE THIS to your real backend URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // Add headers, interceptors later if needed (e.g. for token)
    ),
  );
});

// Repository provider (now depends on dio)
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final dio = ref.watch(dioProvider);
  final apiService = AuthApiService(dio); // ← now passing dio
  final storage = SecureStorage();
  return AuthRepositoryImpl(apiService: apiService, storage: storage);
});

// Auth controller as AsyncNotifierProvider
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  late AuthRepositoryImpl _repository;

  @override
  Future<AuthSession?> build() async {
    _repository = ref.watch(authRepositoryProvider);

    // Auto-load saved token/session on provider initialization
    final token = await _repository.storage.readToken();
    if (token != null) {
      return AuthSession(token: token);
    }
    return null;
  }

  Future<void> login(String email, String password,String role) async {
    state = const AsyncLoading();
    try {
      final session = await _repository.login(email, password,role);
      state = AsyncData(session);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow; // optional: rethrow if you want UI to catch too
    }
  }

  Future<void> signup(String name, String email, String password, String role) async {
    state = const AsyncLoading();
    try {
      final session = await _repository.signup(name, email, password, role);
      state = AsyncData(session);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await _repository.logout();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<UserProfile> loadProfile() {
    return _repository.loadProfile();
  }
}