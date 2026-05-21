class NotificationSettingsRequestDto {
  final bool notificationsEnabled;
  final bool jobAlertsEnabled;

  const NotificationSettingsRequestDto({
    required this.notificationsEnabled,
    required this.jobAlertsEnabled,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notificationsEnabled': notificationsEnabled,
      'jobAlertsEnabled': jobAlertsEnabled,
    };
  }
}

class PrivacySettingsRequestDto {
  final bool profileVisible;
  final bool showPhoneNumber;

  const PrivacySettingsRequestDto({
    required this.profileVisible,
    required this.showPhoneNumber,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profileVisible': profileVisible,
      'showPhoneNumber': showPhoneNumber,
    };
  }
}
