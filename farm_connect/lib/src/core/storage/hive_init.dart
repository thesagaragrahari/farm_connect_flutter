// src/core/storage/hive_init.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/domain/entities/user_profile.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>('user_profile');
  await Hive.openBox<String>('app_settings');
}
