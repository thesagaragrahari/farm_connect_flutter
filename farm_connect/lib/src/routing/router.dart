import 'package:farm_connect/src/core/util/go_router_refresh_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/dashboard_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    // Use the refresh notifier that listens to authControllerProvider
    refreshListenable: ref.watch(goRouterRefreshProvider),

    redirect: (context, state) {
      // Watch the async auth state
      final authAsync = ref.watch(authControllerProvider);

      // loggedIn = we have a non-null session (and no error/loading issues)
      final loggedIn = authAsync.hasValue && authAsync.value != null;

      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/signup';

      // Not logged in and trying to access protected route → go to login
      if (!loggedIn && !isLoggingIn) {
        return '/login';
      }

      // Already logged in and on login/signup → redirect to dashboard
      if (loggedIn && isLoggingIn) {
        return '/dashboard';
      }

      // Otherwise allow the route
      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
});