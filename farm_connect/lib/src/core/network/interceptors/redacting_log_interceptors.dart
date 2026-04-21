// src/core/network/interceptors/redacting_log_interceptor.dart
import 'package:dio/dio.dart';

class RedactingLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = Map<String, dynamic>.from(options.data ?? {});
    if (data.containsKey('password')) data['password'] = '***';
    print('Request: ${options.method} ${options.path} data: $data');
    super.onRequest(options, handler);
  }
}