class UserProfileDetails {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? role;
  final String? profileImageUrl;
  final String? location;
  final String? address;
  final String? bio;
  final String? language;
  final int profileCompletion;
  final WorkerProfileDetails? workerProfile;
  final FarmerProfileDetails? farmerProfile;
  final UserSettings settings;

  const UserProfileDetails({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.role,
    this.profileImageUrl,
    this.location,
    this.address,
    this.bio,
    this.language,
    required this.profileCompletion,
    this.workerProfile,
    this.farmerProfile,
    required this.settings,
  });

  bool get isWorker => role?.toLowerCase() == 'worker';
  bool get isFarmer => role?.toLowerCase() == 'farmer';
}

class WorkerProfileDetails {
  final List<String> skills;
  final String? experience;
  final bool isAvailable;
  final num? expectedWage;
  final String? preferredWorkType;
  final String? workRadius;
  final String? workLocation;
  final List<String> previousWorkHistory;

  const WorkerProfileDetails({
    required this.skills,
    this.experience,
    required this.isAvailable,
    this.expectedWage,
    this.preferredWorkType,
    this.workRadius,
    this.workLocation,
    required this.previousWorkHistory,
  });
}

class FarmerProfileDetails {
  final String? farmType;
  final String? landSize;
  final String? farmingCategory;
  final List<String> seasonalHiringPreferences;

  const FarmerProfileDetails({
    this.farmType,
    this.landSize,
    this.farmingCategory,
    required this.seasonalHiringPreferences,
  });
}

class UserSettings {
  final bool notificationsEnabled;
  final bool jobAlertsEnabled;
  final bool profileVisible;
  final bool showPhoneNumber;

  const UserSettings({
    required this.notificationsEnabled,
    required this.jobAlertsEnabled,
    required this.profileVisible,
    required this.showPhoneNumber,
  });

  UserSettings copyWith({
    bool? notificationsEnabled,
    bool? jobAlertsEnabled,
    bool? profileVisible,
    bool? showPhoneNumber,
  }) {
    return UserSettings(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      jobAlertsEnabled: jobAlertsEnabled ?? this.jobAlertsEnabled,
      profileVisible: profileVisible ?? this.profileVisible,
      showPhoneNumber: showPhoneNumber ?? this.showPhoneNumber,
    );
  }
}
