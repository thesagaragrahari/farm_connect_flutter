import 'package:dio/dio.dart';
import 'package:farm_connect/src/core/constants/dashboard_endpoints.dart';

import '../../domain/entities/dashboard_summary.dart';

class DashboardApiService {
  final Dio dio;

  const DashboardApiService(this.dio);

  Future<DashboardSummary> summary() async {
    final res = await dio.get(DashboardEndpoints.summary);
    final map = _dataMap(res.data);
    return DashboardSummary(
      activeWorkers: _intValue(map['activeWorkers'] ?? map['workers']),
      activeJobs: _intValue(map['activeJobs'] ?? map['jobs']),
      profileCompletion: _intValue(map['profileCompletion']),
    );
  }
}

Map<String, dynamic> _dataMap(Object? raw) {
  final map = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
  final data = map['data'];
  if (data is Map) return Map<String, dynamic>.from(data);
  return map;
}

int _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse((value ?? '').toString()) ?? 0;
}
