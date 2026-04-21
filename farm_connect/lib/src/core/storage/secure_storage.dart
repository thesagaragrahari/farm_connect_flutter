// src/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> writeToken(String token) async =>
      _storage.write(key: 'auth_token', value: token);

  Future<String?> readToken() async => _storage.read(key: 'auth_token');

  Future<void> clear() async => _storage.deleteAll();
}