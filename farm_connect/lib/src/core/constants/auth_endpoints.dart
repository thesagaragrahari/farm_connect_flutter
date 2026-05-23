class AuthEndpoints {
  static const String baseUrl = 'https://farm-connect-backend-1.onrender.com';

  // Auth
  static const String login = '/api/auth/login';
  static const String registerUser = '/api/auth/register/user';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String testEmail = '/api/auth/email';

  // Profile
  static const String completeFarmer = '/api/users/complete-profile/farmer';
  static const String completeWorker = '/api/users/complete-profile/worker';
  static const String workerSkills = '/api/users/get/worker/skills';

  // Jobs
  static const String postJob = '/api/jobs/farmer/postjob';
  static const String activeWorkers = '/api/users/filter/workers/available';
}
