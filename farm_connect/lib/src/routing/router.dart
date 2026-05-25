import 'package:farm_connect/src/core/common_widgets/app_top_bar.dart';
import 'package:farm_connect/src/core/layout/responsive_layout.dart';
import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/core/util/go_router_refresh_stream.dart';
import 'package:farm_connect/src/features/auth/application/auth_controller.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/dashboard_page.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/login_page.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/reset_password_page.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/signup_page.dart';
import 'package:farm_connect/src/features/auth/presentation/pages/verify_email_page.dart';
import 'package:farm_connect/src/features/preview/presentation/pages/public_job_preview_page.dart';
import 'package:farm_connect/src/features/preview/presentation/pages/public_worker_preview_page.dart';
import 'package:farm_connect/src/features/splash/presentation/splash_page.dart';
import 'package:farm_connect/src/features/user/presentation/pages/active_users.dart';
import 'package:farm_connect/src/features/user/presentation/pages/edit_profile_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/farmer_dashboard.dart';
import 'package:farm_connect/src/features/user/presentation/pages/farmer_details_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/job_post.dart';
import 'package:farm_connect/src/features/user/presentation/pages/manage_job_page.dart';
import 'package:farm_connect/src/features/user/presentation/pages/profile_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/public_profile_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/settings_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/skill_selection_screen.dart';
import 'package:farm_connect/src/features/user/presentation/pages/user_module_preview_page.dart';
import 'package:farm_connect/src/features/user/presentation/pages/worker_details_screen.dart';
import 'package:farm_connect/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: false,
    refreshListenable: ref.watch(goRouterRefreshProvider),
    redirect: (context, state) {
      final path = state.uri.path;
      final authState = ref.watch(authControllerProvider);

      final legacyRedirect = _legacyRedirect(path);
      if (legacyRedirect != null) return legacyRedirect;

      if (authState.isLoading || authState.isRefreshing) return null;

      final loggedIn = authState.hasValue && authState.value != null;

      if (path == AppRoutes.root || path == AppRoutes.splash) {
        return loggedIn ? AppRoutes.dashboard : AppRoutes.login;
      }

      if (AppRoutes.isAuth(path) && loggedIn) {
        return AppRoutes.dashboard;
      }

      if (!loggedIn && !AppRoutes.isPublic(path)) {
        return AppRoutes.login;
      }

      final requiredRole = AppRoutes.requiredRoleFor(path);
      final sessionRole = authState.value?.role?.toLowerCase();
      if (loggedIn &&
          requiredRole != null &&
          sessionRole != null &&
          sessionRole != requiredRole) {
        return AppRoutes.unauthorized;
      }

      return null;
    },
    errorPageBuilder: (context, state) => _buildAnimatedPage(
      state,
      RouteStatePage.notFound(
        message: 'We could not find ${state.uri.path}.',
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          const SplashPage(nextLocation: AppRoutes.login),
        ),
      ),
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          const SplashPage(nextLocation: AppRoutes.login),
        ),
      ),
      GoRoute(
        path: AppRoutes.preview,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const UserModulePreviewPage()),
      ),
      GoRoute(
        path: '${AppRoutes.previewProfileBase}/:userId',
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          PublicProfileScreen(userId: state.pathParameters['userId'] ?? ''),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.previewWorkerBase}/:workerId',
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          PublicWorkerPreviewPage(
            workerId: state.pathParameters['workerId'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.previewJobBase}/:jobId',
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          PublicJobPreviewPage(jobId: state.pathParameters['jobId'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.unauthorized,
        pageBuilder: (context, state) => _buildAnimatedPage(
          state,
          const RouteStatePage.unauthorized(),
        ),
      ),
      GoRoute(
        path: AppRoutes.auth,
        redirect: (_, __) => AppRoutes.login,
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.signup,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SignupPage()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ForgotPasswordPage()),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ResetPasswordPage()),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const VerifyEmailPage()),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const DashboardPage()),
      ),
      GoRoute(
        path: AppRoutes.farmerDashboard,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const FarmerDashboardPage()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.workerProfile,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const WorkerDetailsScreen()),
      ),
      GoRoute(
        path: AppRoutes.workerSkills,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SkillSelectionScreen()),
      ),
      GoRoute(
        path: AppRoutes.farmerProfile,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const FarmerDetailsScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.activeUsers,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ActiveUsersPage()),
      ),
      GoRoute(
        path: AppRoutes.manageJobs,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const ManageJobsPage()),
      ),
      GoRoute(
        path: AppRoutes.postJob,
        pageBuilder: (context, state) =>
            _buildAnimatedPage(state, const JobPostPage()),
      ),
      GoRoute(
        path: AppRoutes.workerProfileLegacy,
        redirect: (_, __) => AppRoutes.workerProfile,
      ),
    ],
  );
});

String? _legacyRedirect(String path) {
  return switch (path) {
    '/login' => AppRoutes.login,
    '/signup' => AppRoutes.signup,
    '/forgot-password' => AppRoutes.forgotPassword,
    '/reset-password' => AppRoutes.resetPassword,
    '/verify-email' => AppRoutes.verifyEmail,
    '/preview/auth/login' => AppRoutes.login,
    '/preview/auth/signup' => AppRoutes.signup,
    '/preview/auth/forgot-password' => AppRoutes.forgotPassword,
    '/preview/auth/reset-password' => AppRoutes.resetPassword,
    '/preview/auth/verify-email' => AppRoutes.verifyEmail,
    _ when path.startsWith('/profile/public/') =>
      '${AppRoutes.previewProfileBase}/${path.split('/').last}',
    _ => null,
  };
}

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

class RouteStatePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const RouteStatePage._({
    required this.icon,
    required this.title,
    required this.message,
  });

  const RouteStatePage.unauthorized()
      : this._(
          icon: Icons.lock_outline_rounded,
          title: 'Access Required',
          message: 'Sign in to continue to this workspace.',
        );

  const RouteStatePage.notFound({required String message})
      : this._(
          icon: Icons.travel_explore_rounded,
          title: 'Page Not Found',
          message: message,
        );

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette(context);

    return Scaffold(
      appBar: appTopBar(title: const Text('FarmConnect')),
      body: AppScreen(
        child: ResponsivePage(
          maxWidth: 560,
          child: Center(
            child: AppSurface(
              featured: true,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        AppTheme.forestGreen.withValues(alpha: 0.13),
                    child: Icon(icon, color: AppTheme.forestGreen),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: palette.primaryText,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.secondaryText,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
