import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sources/dashboard_api_service.dart';
import '../domain/entities/dashboard_summary.dart';

final dashboardApiProvider = Provider<DashboardApiService>((ref) {
  return DashboardApiService(ref.watch(dioProvider));
});

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) {
  return ref.watch(dashboardApiProvider).summary();
});
