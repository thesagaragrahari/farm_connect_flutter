// src/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/network/interceptors/auth_interceptors.dart';
import 'package:farm_connect/src/core/network/interceptors/redacting_log_interceptors.dart';

import '../env/app_config.dart';

class DioClient {
  static Dio create({String? token}) {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status < 500,
    ));

    dio.interceptors.addAll([
      RedactingLogInterceptor(),
      if (token != null) AuthInterceptor(token),
    ]);

    return dio;
  }
}
