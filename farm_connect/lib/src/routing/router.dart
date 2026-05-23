import 'package:farm_connect/src/core/util/go_router_refresh_stream.dart';
import 'package:farm_connect/src/features/splash/presentation/splash_page.dart';
import 'package:farm_connect/src/features/user/presentation/pages/active_users.dart';
import 'package:farm_connect/src/features/user/presentation/pages/edit_profile_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/farmer_details_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/farmer_dashboard.dart';
import 'package:farm_connect/src/features/user/presentation/pages/job_post.dart';
import 'package:farm_connect/src/features/user/presentation/pages/manage_job_page.dart';
import 'package:farm_connect/src/features/user/presentation/pages/profile_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/public_profile_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/settings_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/skill_selection_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/user_module_preview_page.dart';
import 'package:farm_connect/src/features/user/presentation/pages/worker_details_screen.dart';
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
    initialLocation: '/splash',
    //initialLocation: '/login',

    // Use the refresh notifier that listens to authControllerProvider
    refreshListenable: ref.watch(goRouterRefreshProvider),

    redirect: (context, state) {
      // Watch the async auth state
      final authAsync = ref.watch(authControllerProvider);

      // loggedIn = we have a non-null session (and no error/loading issues)
      final loggedIn = authAsync.hasValue && authAsync.value != null;

      const previewRoutes = <String>{
        '/splash',
        '/preview',
        '/preview/auth/login',
        '/preview/auth/signup',
        '/preview/auth/forgot-password',
        '/preview/auth/reset-password',
        '/preview/auth/verify-email',
        '/farmer-dashboard',
        '/profile',
        '/profile/edit',
        '/profile/worker',
        '/profile/worker/skills',
        '/profile/farmer',
        '/settings',
        '/active-users',
        '/manage-jobs',
        '/post-job',
        '/worker-profile',
      };

      const authRoutes = <String>{
        '/login',
        '/signup',
        '/forgot-password',
        '/reset-password',
        '/verify-email',
      };

      final isPreviewRoute = previewRoutes.contains(state.uri.path) ||
          state.uri.path.startsWith('/profile/public/');
      final isAuthRoute = authRoutes.contains(state.uri.path);
      final isPublicRoute = isPreviewRoute || isAuthRoute;

      // Not logged in and trying to access protected route → go to login
      if (!loggedIn && !isPublicRoute) {
        return '/login';
      }

      // Already logged in and on login/signup → redirect to dashboard
      if (loggedIn && isAuthRoute) {
        return '/dashboard';
      }

      // Otherwise allow the route
      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SplashPage()),
      ),
      GoRoute(
        path: '/preview',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const UserModulePreviewPage()),
      ),
      GoRoute(
        path: '/preview/auth/login',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const LoginPage()),
      ),
      GoRoute(
        path: '/preview/auth/signup',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SignupPage()),
      ),
      GoRoute(
        path: '/preview/auth/forgot-password',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ForgotPasswordPage()),
      ),
      GoRoute(
        path: '/preview/auth/reset-password',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ResetPasswordPage()),
      ),
      GoRoute(
        path: '/preview/auth/verify-email',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const VerifyEmailPage()),
      ),
      GoRoute(
        path: '/farmer-dashboard',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const FarmerDashboardPage()),
      ),
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
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ProfileScreen()),
      ),
      GoRoute(
        path: '/profile/edit',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: '/profile/worker',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const WorkerDetailsScreen()),
      ),
      GoRoute(
        path: '/profile/worker/skills',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SkillSelectionScreen()),
      ),
      GoRoute(
        path: '/profile/farmer',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const FarmerDetailsScreen()),
      ),
      GoRoute(
        path: '/profile/public/:userId',
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          PublicProfileScreen(userId: state.pathParameters['userId'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/active-users',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ActiveUsersPage()),
      ),
      GoRoute(
        path: '/manage-jobs',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ManageJobsPage()),
      ),
      GoRoute(
        path: '/post-job',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const JobPostPage()),
      ),
      GoRoute(
        path: '/worker-profile',
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const WorkerDetailsScreen()),
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
