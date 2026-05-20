// user_profile.dart
import 'package:hive/hive.dart';
part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;
  const UserProfile({required this.name, required this.email});
}