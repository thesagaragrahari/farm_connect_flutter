// src/core/network/interceptors/redacting_log_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RedactingLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final raw = options.data;
    final data = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    if (data.containsKey('password')) data['password'] = '***';
    if (data.containsKey('newPassword')) data['newPassword'] = '***';
    debugPrint('Request: ${options.method} ${options.path} data: $data');
    super.onRequest(options, handler);
  }
}
