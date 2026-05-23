import '../../domain/entities/user_profile_details.dart';

class UserProfileResponseDto {
  final UserProfileDetails profile;

  const UserProfileResponseDto({required this.profile});

  factory UserProfileResponseDto.fromJson(Map<String, dynamic> json) {
    final data = _dataMap(json);
    return UserProfileResponseDto(
      profile: UserProfileDto.fromJson(data).toEntity(),
    );
  }
}

class UserListResponseDto {
  final List<UserProfileDetails> users;
  final int page;
  final int limit;
  final bool hasMore;

  const UserListResponseDto({
    required this.users,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory UserListResponseDto.fromJson(Map<String, dynamic> json) {
    final data = _dataMap(json);
    final rawList = data['users'] ?? data['workers'] ?? data['items'] ?? data['data'];
    final list = rawList is List ? rawList : const [];
    final page = _intValue(data['page'], fallback: 1);
    final limit = _intValue(data['limit'], fallback: list.length);

    return UserListResponseDto(
      users: list
          .whereType<Map>()
          .map((item) => UserProfileDto.fromJson(Map<String, dynamic>.from(item)).toEntity())
          .toList(),
      page: page,
      limit: limit,
      hasMore: data['hasMore'] is bool
          ? data['hasMore'] as bool
          : list.length >= limit && list.isNotEmpty,
    );
  }
}

class UserProfileDto {
  final Map<String, dynamic> json;

  const UserProfileDto({required this.json});

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(json: json);
  }

  UserProfileDetails toEntity() {
    final worker = _mapValue(json['workerProfile'] ?? json['worker']);
    final farmer = _mapValue(json['farmerProfile'] ?? json['farmer']);

    return UserProfileDetails(
      id: _stringValue(json['_id'] ?? json['id']),
      fullName: _stringValue(json['fullName'] ?? json['name']),
      email: _stringValue(json['email']),
      phone: _stringOrNull(json['phone'] ?? json['mobileNumber']),
      role: _stringOrNull(json['role']),
      profileImageUrl: _stringOrNull(json['profileImageUrl'] ?? json['avatar']),
      location: _stringOrNull(json['location'] ?? json['city']),
      address: _stringOrNull(json['address']),
      bio: _stringOrNull(json['bio'] ?? json['about']),
      language: _stringOrNull(json['language']),
      profileCompletion: _completionValue(json),
      workerProfile: worker != null ? WorkerProfileDto.fromJson(worker).toEntity() : null,
      farmerProfile: farmer != null ? FarmerProfileDto.fromJson(farmer).toEntity() : null,
      settings: UserSettingsDto.fromJson(_mapValue(json['settings']) ?? const {}).toEntity(),
    );
  }
}

class WorkerProfileDto {
  final Map<String, dynamic> json;

  const WorkerProfileDto({required this.json});

  factory WorkerProfileDto.fromJson(Map<String, dynamic> json) {
    return WorkerProfileDto(json: json);
  }

  WorkerProfileDetails toEntity() {
    return WorkerProfileDetails(
      skills: _stringList(json['skills']),
      experience: _stringOrNull(json['experience']),
      isAvailable: _boolValue(
        json['availabilityStatus'] ?? json['isAvailable'],
        fallback: true,
      ),
      expectedWage: _numOrNull(json['expectedWage'] ?? json['wage']),
      preferredWorkType: _stringOrNull(json['preferredWorkType']),
      workRadius: _stringOrNull(json['workRadius']),
      workLocation: _stringOrNull(json['workLocation'] ?? json['location']),
      previousWorkHistory: _stringList(
        json['previousWorkHistory'] ?? json['workHistory'],
      ),
    );
  }
}

class FarmerProfileDto {
  final Map<String, dynamic> json;

  const FarmerProfileDto({required this.json});

  factory FarmerProfileDto.fromJson(Map<String, dynamic> json) {
    return FarmerProfileDto(json: json);
  }

  FarmerProfileDetails toEntity() {
    return FarmerProfileDetails(
      farmType: _stringOrNull(json['farmType']),
      landSize: _stringOrNull(json['landSize']),
      farmingCategory: _stringOrNull(json['farmingCategory']),
      seasonalHiringPreferences: _stringList(json['seasonalHiringPreferences']),
    );
  }
}

class UserSettingsDto {
  final Map<String, dynamic> json;

  const UserSettingsDto({required this.json});

  factory UserSettingsDto.fromJson(Map<String, dynamic> json) {
    return UserSettingsDto(json: json);
  }

  UserSettings toEntity() {
    return UserSettings(
      notificationsEnabled: _boolValue(json['notificationsEnabled'], fallback: true),
      jobAlertsEnabled: _boolValue(json['jobAlertsEnabled'], fallback: true),
      profileVisible: _boolValue(json['profileVisible'], fallback: true),
      showPhoneNumber: _boolValue(json['showPhoneNumber'], fallback: false),
    );
  }
}

Map<String, dynamic> _dataMap(Map<String, dynamic> json) {
  final raw = json['data'];
  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);
    final profile = map['profile'] ?? map['user'] ?? map['userProfile'];
    if (profile is Map) return Map<String, dynamic>.from(profile);
    return map;
  }

  final profile = json['profile'] ?? json['user'] ?? json['userProfile'];
  if (profile is Map) return Map<String, dynamic>.from(profile);
  return json;
}

Map<String, dynamic>? _mapValue(Object? value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String _stringValue(Object? value) => value?.toString() ?? '';

String? _stringOrNull(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  final text = _stringOrNull(value);
  if (text == null) return const [];
  return text
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

bool _boolValue(Object? value, {required bool fallback}) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return fallback;
}

num? _numOrNull(Object? value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '');
}

int _intValue(Object? value, {required int fallback}) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

int _completionValue(Map<String, dynamic> json) {
  final raw = json['profileCompletion'] ?? json['profileCompletionPercentage'];
  if (raw is num) return raw.clamp(0, 100).toInt();
  final parsed = int.tryParse(raw?.toString() ?? '');
  if (parsed != null) return parsed.clamp(0, 100);

  final fields = <Object?>[
    json['fullName'] ?? json['name'],
    json['email'],
    json['phone'],
    json['location'],
    json['bio'] ?? json['about'],
  ];
  final filled = fields.where((item) => _stringOrNull(item) != null).length;
  return ((filled / fields.length) * 100).round();
}
