class AppRoutes {
  static const root = '/';
  static const splash = '/splash';

  static const auth = '/auth';
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const verifyEmail = '/auth/verify-email';

  static const dashboard = '/dashboard';
  static const farmerDashboard = '/farmer-dashboard';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const workerProfile = '/profile/worker';
  static const workerSkills = '/profile/worker/skills';
  static const farmerProfile = '/profile/farmer';
  static const settings = '/settings';
  static const activeUsers = '/active-users';
  static const manageJobs = '/manage-jobs';
  static const postJob = '/post-job';
  static const workerProfileLegacy = '/worker-profile';

  static const preview = '/preview';
  static const previewProfileBase = '/preview/profile';
  static const previewJobBase = '/preview/job';
  static const previewWorkerBase = '/preview/worker';
  static String previewProfile(String id) => '$previewProfileBase/$id';
  static String previewJob(String id) => '$previewJobBase/$id';
  static String previewWorker(String id) => '$previewWorkerBase/$id';

  static const unauthorized = '/unauthorized';

  static bool isPublic(String path) {
    return path == root ||
        path == splash ||
        path == auth ||
        path == login ||
        path == signup ||
        path == forgotPassword ||
        path == resetPassword ||
        path == verifyEmail ||
        path == preview ||
        path == unauthorized ||
        path.startsWith('$previewProfileBase/') ||
        path.startsWith('$previewJobBase/') ||
        path.startsWith('$previewWorkerBase/');
  }

  static bool isAuth(String path) {
    return path == auth ||
        path == login ||
        path == signup ||
        path == forgotPassword ||
        path == resetPassword ||
        path == verifyEmail;
  }

  static String? requiredRoleFor(String path) {
    return switch (path) {
      farmerDashboard || farmerProfile || manageJobs || postJob => 'farmer',
      workerProfile || workerSkills => 'worker',
      _ => null,
    };
  }
}
