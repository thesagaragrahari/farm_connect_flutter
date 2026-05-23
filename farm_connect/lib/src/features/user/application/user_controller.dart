import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/user_repository_impl.dart';
import '../data/sources/user_api_service.dart';
import '../domain/entities/user_profile_details.dart';

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final dio = ref.watch(dioProvider);
  final apiService = UserApiService(dio);
  return UserRepositoryImpl(apiService: apiService);
});

final userControllerProvider =
    AsyncNotifierProvider<UserController, UserState>(UserController.new);

class UserState {
  final UserProfileDetails? profile;
  final List<UserProfileDetails> workers;
  final bool isSaving;
  final bool hasMoreWorkers;
  final int workerPage;

  const UserState({
    this.profile,
    this.workers = const [],
    this.isSaving = false,
    this.hasMoreWorkers = true,
    this.workerPage = 1,
  });

  UserState copyWith({
    UserProfileDetails? profile,
    List<UserProfileDetails>? workers,
    bool? isSaving,
    bool? hasMoreWorkers,
    int? workerPage,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      workers: workers ?? this.workers,
      isSaving: isSaving ?? this.isSaving,
      hasMoreWorkers: hasMoreWorkers ?? this.hasMoreWorkers,
      workerPage: workerPage ?? this.workerPage,
    );
  }
}

class UserController extends AsyncNotifier<UserState> {
  late UserRepositoryImpl _repository;

  @override
  Future<UserState> build() async {
    _repository = ref.watch(userRepositoryProvider);
    final profile = await _repository.getProfile();
    return UserState(profile: profile);
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final profile = await _repository.getProfile();
      return UserState(profile: profile);
    });
  }

  Future<void> updateProfile({
    required String fullName,
    String? phone,
    String? location,
    String? address,
    String? bio,
    String? language,
  }) async {
    await _save(() async {
      final profile = await _repository.updateProfile(
        fullName: fullName,
        phone: phone,
        location: location,
        address: address,
        bio: bio,
        language: language,
      );
      return _current.copyWith(profile: profile);
    }, fallback: 'Profile update failed');
  }

  Future<void> uploadProfileImage(File file) async {
    await _save(() async {
      await _repository.uploadProfileImage(file);
      final profile = await _repository.getProfile();
      return _current.copyWith(profile: profile);
    }, fallback: 'Profile image upload failed');
  }

  Future<void> updateWorkerProfile({
    required List<String> skills,
    String? experience,
    required bool isAvailable,
    num? expectedWage,
    String? preferredWorkType,
    String? workRadius,
    String? workLocation,
    required List<String> previousWorkHistory,
  }) async {
    await _save(() async {
      final profile = await _repository.updateWorkerProfile(
        skills: skills,
        experience: experience,
        isAvailable: isAvailable,
        expectedWage: expectedWage,
        preferredWorkType: preferredWorkType,
        workRadius: workRadius,
        workLocation: workLocation,
        previousWorkHistory: previousWorkHistory,
      );
      return _current.copyWith(profile: profile);
    }, fallback: 'Worker profile update failed');
  }

  Future<void> updateFarmerProfile({
    String? farmType,
    String? landSize,
    String? farmingCategory,
    required List<String> seasonalHiringPreferences,
  }) async {
    await _save(() async {
      final profile = await _repository.updateFarmerProfile(
        farmType: farmType,
        landSize: landSize,
        farmingCategory: farmingCategory,
        seasonalHiringPreferences: seasonalHiringPreferences,
      );
      return _current.copyWith(profile: profile);
    }, fallback: 'Farmer profile update failed');
  }

  Future<UserProfileDetails> getPublicProfile(String userId) {
    return _repository.getPublicProfile(userId);
  }

  Future<void> loadWorkers({
    String? skill,
    String? location,
    bool reset = false,
  }) async {
    final current = _current;
    if (!reset && !current.hasMoreWorkers) return;

    final nextPage = reset ? 1 : current.workerPage;
    try {
      final workers = await _repository.getAvailableWorkers(
        skill: skill,
        location: location,
        page: nextPage,
      );

      state = AsyncData(
        current.copyWith(
          workers: reset ? workers : [...current.workers, ...workers],
          workerPage: nextPage + 1,
          hasMoreWorkers: workers.isNotEmpty,
        ),
      );
    } on DioException {
      state = AsyncData(
        current.copyWith(
          workers: reset ? const [] : current.workers,
          hasMoreWorkers: false,
        ),
      );
    }
  }

  Future<void> updateNotificationSettings({
    required bool notificationsEnabled,
    required bool jobAlertsEnabled,
  }) async {
    await _save(() async {
      final settings = await _repository.updateNotificationSettings(
        notificationsEnabled: notificationsEnabled,
        jobAlertsEnabled: jobAlertsEnabled,
      );
      return _current.copyWith(profile: _profileWithSettings(settings));
    }, fallback: 'Notification settings update failed');
  }

  Future<void> updatePrivacySettings({
    required bool profileVisible,
    required bool showPhoneNumber,
  }) async {
    await _save(() async {
      final settings = await _repository.updatePrivacySettings(
        profileVisible: profileVisible,
        showPhoneNumber: showPhoneNumber,
      );
      return _current.copyWith(profile: _profileWithSettings(settings));
    }, fallback: 'Privacy settings update failed');
  }

  Future<String> deactivateAccount() {
    return _repository.deactivateAccount();
  }

  Future<void> _save(
    Future<UserState> Function() action, {
    required String fallback,
  }) async {
    final previous = _current;
    state = AsyncData(previous.copyWith(isSaving: true));
    try {
      final next = await action();
      state = AsyncData(next.copyWith(isSaving: false));
    } on DioException catch (e, stackTrace) {
      state = AsyncError(_extractDioMessage(e, fallback: fallback), stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e.toString(), stackTrace);
    }
  }

  UserState get _current => state.value ?? const UserState();

  UserProfileDetails _profileWithSettings(UserSettings settings) {
    final profile = _current.profile;
    if (profile == null) {
      throw Exception('Profile not loaded');
    }

    return UserProfileDetails(
      id: profile.id,
      fullName: profile.fullName,
      email: profile.email,
      phone: profile.phone,
      role: profile.role,
      profileImageUrl: profile.profileImageUrl,
      location: profile.location,
      address: profile.address,
      bio: profile.bio,
      language: profile.language,
      profileCompletion: profile.profileCompletion,
      workerProfile: profile.workerProfile,
      farmerProfile: profile.farmerProfile,
      settings: settings,
    );
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
