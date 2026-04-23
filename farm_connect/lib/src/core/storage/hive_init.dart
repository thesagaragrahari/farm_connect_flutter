// src/core/storage/hive_init.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/domain/entities/user_profile.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  final adapter = UserProfileAdapter();
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }

  if (!Hive.isBoxOpen('user_profile')) {
    await Hive.openBox<UserProfile>('user_profile');
  }
}
