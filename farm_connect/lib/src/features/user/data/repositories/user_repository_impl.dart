import 'dart:io';

import '../../domain/entities/user_profile_details.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../dto/farmer_profile_request_dto.dart';
import '../dto/update_profile_request_dto.dart';
import '../dto/user_settings_request_dto.dart';
import '../dto/worker_profile_request_dto.dart';
import '../sources/user_api_service.dart';

class UserRepositoryImpl implements IUserRepository {
  final UserApiService apiService;

  const UserRepositoryImpl({required this.apiService});

  @override
  Future<UserProfileDetails> getProfile() async {
    final res = await apiService.getProfile();
    return res.profile;
  }

  @override
  Future<UserProfileDetails> updateProfile({
    required String fullName,
    String? phone,
    String? location,
    String? address,
    String? bio,
    String? language,
  }) async {
    final dto = UpdateProfileRequestDto(
      fullName: fullName,
      phone: phone,
      location: location,
      address: address,
      bio: bio,
      language: language,
    );
    final res = await apiService.updateProfile(dto);
    return res.profile;
  }

  @override
  Future<String> uploadProfileImage(File file) {
    return apiService.uploadProfileImage(file);
  }

  @override
  Future<UserProfileDetails> updateWorkerProfile({
    required List<String> skills,
    String? experience,
    required bool isAvailable,
    num? expectedWage,
    String? preferredWorkType,
    String? workRadius,
    String? workLocation,
    required List<String> previousWorkHistory,
  }) async {
    final dto = WorkerProfileRequestDto(
      skills: skills,
      experience: experience,
      isAvailable: isAvailable,
      expectedWage: expectedWage,
      preferredWorkType: preferredWorkType,
      workRadius: workRadius,
      workLocation: workLocation,
      previousWorkHistory: previousWorkHistory,
    );
    final res = await apiService.updateWorkerProfile(dto);
    return res.profile;
  }

  @override
  Future<UserProfileDetails> updateFarmerProfile({
    String? farmType,
    String? landSize,
    String? farmingCategory,
    required List<String> seasonalHiringPreferences,
  }) async {
    final dto = FarmerProfileRequestDto(
      farmType: farmType,
      landSize: landSize,
      farmingCategory: farmingCategory,
      seasonalHiringPreferences: seasonalHiringPreferences,
    );
    final res = await apiService.updateFarmerProfile(dto);
    return res.profile;
  }

  @override
  Future<UserProfileDetails> getPublicProfile(String userId) async {
    final res = await apiService.getPublicProfile(userId);
    return res.profile;
  }

  @override
  Future<List<UserProfileDetails>> getAvailableWorkers({
    String? skill,
    String? location,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await apiService.getAvailableWorkers(
      skill: skill,
      location: location,
      page: page,
      limit: limit,
    );
    return res.users;
  }

  @override
  Future<UserSettings> updateNotificationSettings({
    required bool notificationsEnabled,
    required bool jobAlertsEnabled,
  }) async {
    final dto = NotificationSettingsRequestDto(
      notificationsEnabled: notificationsEnabled,
      jobAlertsEnabled: jobAlertsEnabled,
    );
    return (await apiService.updateNotificationSettings(dto)).toEntity();
  }

  @override
  Future<UserSettings> updatePrivacySettings({
    required bool profileVisible,
    required bool showPhoneNumber,
  }) async {
    final dto = PrivacySettingsRequestDto(
      profileVisible: profileVisible,
      showPhoneNumber: showPhoneNumber,
    );
    return (await apiService.updatePrivacySettings(dto)).toEntity();
  }

  @override
  Future<String> deactivateAccount() {
    return apiService.deactivateAccount();
  }
}
