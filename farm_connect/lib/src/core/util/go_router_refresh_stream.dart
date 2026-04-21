import 'package:farm_connect/src/features/auth/domain/entities/auth_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/auth_controller.dart'; // adjust import path if needed

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier();
}

final goRouterRefreshProvider = Provider<GoRouterRefreshNotifier>((ref) {
  final notifier = GoRouterRefreshNotifier();

  ref.listen<AsyncValue<AuthSession?>>(
    authControllerProvider,
    (previous, next) {
      // Check if logged-in status changed
      final wasLoggedIn = previous?.value != null;
      final isLoggedIn  = next.value != null;

      if (wasLoggedIn != isLoggedIn) {
        notifier.notifyListeners();
      }
      // Optional: always notify on any change (loading → data, error, etc.)
      // notifier.notifyListeners(); // uncomment if you want more frequent refreshes
    },
    fireImmediately: false, // don't trigger on initial listen
  );

  return notifier;
});