import 'package:farm_connect/src/core/util/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/reset_password_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/verify_email_page.dart';
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

      const publicAuthRoutes = <String>{
        '/login',
        '/signup',
        '/forgot-password',
        '/reset-password',
        '/verify-email',
      };

      final isPublicAuthRoute = publicAuthRoutes.contains(state.uri.path);

      // Not logged in and trying to access protected route → go to login
      if (!loggedIn && !isPublicAuthRoute) {
        return '/login';
      }

      // Already logged in and on login/signup → redirect to dashboard
      if (loggedIn && isPublicAuthRoute) {
        return '/dashboard';
      }

      // Otherwise allow the route
      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const LoginPage()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SignupPage()),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ForgotPasswordPage()),
      ),
      GoRoute(
        path: '/reset-password',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ResetPasswordPage()),
      ),
      GoRoute(
        path: '/verify-email',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const VerifyEmailPage()),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const DashboardPage()),
      ),
    ],
  );
});

CustomTransitionPage<void> _buildAnimatedPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
