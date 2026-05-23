class JobEndpoints {
  static const String jobs = '/api/v1/jobs';
  static const String myJobs = '/api/v1/jobs/my';
  static const String publicJobs = '/api/v1/public/jobs';

  static String job(String id) => '$jobs/$id';
  static String publicJob(String id) => '$publicJobs/$id';
  static String apply(String id) => '$jobs/$id/applications';
}
