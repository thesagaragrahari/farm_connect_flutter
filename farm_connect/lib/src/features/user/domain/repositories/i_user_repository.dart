import 'dart:io';

import '../entities/user_profile_details.dart';

abstract class IUserRepository {
  Future<UserProfileDetails> getProfile();
  Future<UserProfileDetails> updateProfile({
    required String fullName,
    String? phone,
    String? location,
    String? address,
    String? bio,
    String? language,
  });
  Future<String> uploadProfileImage(File file);
  Future<UserProfileDetails> updateWorkerProfile({
    required List<String> skills,
    String? experience,
    required bool isAvailable,
    num? expectedWage,
    String? preferredWorkType,
    String? workRadius,
    String? workLocation,
    required List<String> previousWorkHistory,
  });
  Future<UserProfileDetails> updateFarmerProfile({
    String? farmType,
    String? landSize,
    String? farmingCategory,
    required List<String> seasonalHiringPreferences,
  });
  Future<UserProfileDetails> getPublicProfile(String userId);
  Future<List<UserProfileDetails>> getAvailableWorkers({
    String? skill,
    String? location,
    int page = 1,
    int limit = 20,
  });
  Future<UserSettings> updateNotificationSettings({
    required bool notificationsEnabled,
    required bool jobAlertsEnabled,
  });
  Future<UserSettings> updatePrivacySettings({
    required bool profileVisible,
    required bool showPhoneNumber,
  });
  Future<String> deactivateAccount();
}
