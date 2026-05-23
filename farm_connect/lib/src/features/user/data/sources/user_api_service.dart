import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/constants/user_endpoints.dart';

import '../dto/farmer_profile_request_dto.dart';
import '../dto/update_profile_request_dto.dart';
import '../dto/user_profile_response_dto.dart';
import '../dto/user_settings_request_dto.dart';
import '../dto/worker_profile_request_dto.dart';

class UserApiService {
  final Dio dio;
  UserApiService(this.dio);

  Future<UserProfileResponseDto> getProfile() async {
    final res = await dio.get(UserEndpoints.profile);
    return UserProfileResponseDto.fromJson(_asMap(res.data));
  }

  Future<UserProfileResponseDto> updateProfile(
    UpdateProfileRequestDto dto,
  ) async {
    final res = await dio.put(UserEndpoints.updateProfile, data: dto.toJson());
    return UserProfileResponseDto.fromJson(_asMap(res.data));
  }

  Future<String> uploadProfileImage(File file) async {
    final formData = FormData.fromMap(
      <String, dynamic>{
        'image': await MultipartFile.fromFile(file.path),
      },
    );
    final res = await dio.post(
      UserEndpoints.uploadProfileImage,
      data: formData,
    );
    final map = _asMap(res.data);
    return (map['profileImageUrl'] ??
            map['imageUrl'] ??
            map['url'] ??
            _asMap(map['data'])['profileImageUrl'] ??
            '')
        .toString();
  }

  Future<UserProfileResponseDto> updateWorkerProfile(
    WorkerProfileRequestDto dto,
  ) async {
    final res = await dio.post(UserEndpoints.completeWorker, data: dto.toJson());
    return UserProfileResponseDto.fromJson(_asMap(res.data));
  }

  Future<UserProfileResponseDto> updateFarmerProfile(
    FarmerProfileRequestDto dto,
  ) async {
    final res = await dio.post(UserEndpoints.completeFarmer, data: dto.toJson());
    return UserProfileResponseDto.fromJson(_asMap(res.data));
  }

  Future<UserProfileResponseDto> getPublicProfile(String userId) async {
    final res = await dio.get('${UserEndpoints.publicProfile}/$userId');
    return UserProfileResponseDto.fromJson(_asMap(res.data));
  }

  Future<UserListResponseDto> getAvailableWorkers({
    String? skill,
    String? location,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await dio.get(
      UserEndpoints.availableWorkers,
      queryParameters: <String, dynamic>{
        if (_hasValue(skill)) 'skill': skill,
        if (_hasValue(location)) 'location': location,
        'page': page,
        'limit': limit,
      },
    );
    return UserListResponseDto.fromJson(_asMap(res.data));
  }

  Future<UserSettingsDto> updateNotificationSettings(
    NotificationSettingsRequestDto dto,
  ) async {
    final res = await dio.put(
      UserEndpoints.notificationSettings,
      data: dto.toJson(),
    );
    return UserSettingsDto.fromJson(_settingsMap(res.data));
  }

  Future<UserSettingsDto> updatePrivacySettings(
    PrivacySettingsRequestDto dto,
  ) async {
    final res = await dio.put(
      UserEndpoints.privacySettings,
      data: dto.toJson(),
    );
    return UserSettingsDto.fromJson(_settingsMap(res.data));
  }

  Future<String> deactivateAccount() async {
    final res = await dio.post(UserEndpoints.deactivateAccount);
    return _extractMessage(res.data, fallback: 'Account deactivation requested.');
  }
}

Map<String, dynamic> _asMap(Object? raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return <String, dynamic>{};
}

Map<String, dynamic> _settingsMap(Object? raw) {
  final map = _asMap(raw);
  final data = map['data'];
  if (data is Map) return Map<String, dynamic>.from(data);
  final settings = map['settings'];
  if (settings is Map) return Map<String, dynamic>.from(settings);
  return map;
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

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
