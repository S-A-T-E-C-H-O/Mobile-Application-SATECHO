class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'http://agrosafe-back.eastus2.azurecontainer.io:8080';

  // Auth
  static const String signIn = '/api/v1/authentication/sign-in';
  static const String signUp = '/api/v1/authentication/sign-up';
  static const String verifyAccount = '/api/v1/authentication/verify-account';
  static const String resendVerification =
      '/api/v1/authentication/resend-verification';
  static const String forgotPassword = '/api/v1/authentication/forgot-password';
  static const String resetPassword = '/api/v1/authentication/reset-password';

  // Me
  static const String me = '/api/v1/me';
  static const String changePassword = '/api/v1/me/change-password';

  // Farms & Zones
  static const String farms = '/api/v1/farms';
  static String farm(String farmId) => '/api/v1/farms/$farmId';
  static String farmZones(String farmId) => '/api/v1/farms/$farmId/zones';
  static String zone(String zoneId) => '/api/v1/zones/$zoneId';
  static String zoneThresholds(String zoneId) =>
      '/api/v1/zones/$zoneId/thresholds';

  // Telemetry
  static String zoneLatestTelemetry(String zoneId) =>
      '/api/v1/telemetry/zones/$zoneId/latest';
  static String zoneHistoryTelemetry(String zoneId) =>
      '/api/v1/telemetry/zones/$zoneId/history';
  static String zoneTrends(String zoneId) =>
      '/api/v1/telemetry/zones/$zoneId/trends';

  // Soil diagnosis
  static String latestDiagnosis(String zoneId) =>
      '/api/v1/soil/diagnosis/zones/$zoneId/latest';

  // Irrigation
  static String startIrrigation(String zoneId) =>
      '/api/v1/zones/$zoneId/irrigation/start';
  static String stopIrrigation(String zoneId) =>
      '/api/v1/zones/$zoneId/irrigation/stop';
  static String activeIrrigation(String zoneId) =>
      '/api/v1/zones/$zoneId/irrigation/active';
  static String irrigationHistory(String zoneId) =>
      '/api/v1/zones/$zoneId/irrigation/history';
  static String irrigationSchedules(String zoneId) =>
      '/api/v1/zones/$zoneId/irrigation/schedule';
  static String irrigationSchedule(String zoneId, String scheduleId) =>
      '/api/v1/zones/$zoneId/irrigation/schedule/$scheduleId';

  // Actuators
  static String actuatorCommand(String deviceId) =>
      '/api/v1/actuators/$deviceId/command';
  static String actuatorLogs(String deviceId) =>
      '/api/v1/actuators/$deviceId/logs';

  // Notifications
  static const String notifications = '/api/v1/notifications';
  static String notification(String id) => '/api/v1/notifications/$id';
  static const String notificationPreferences =
      '/api/v1/notifications/preferences';
  static const String deviceTokens = '/api/v1/notifications/device-tokens';

  // Recommendations
  static const String recommendations = '/api/v1/recommendations';
  static String recommendation(String id) => '/api/v1/recommendations/$id';
  static String acknowledgeRecommendation(String id) =>
      '/api/v1/recommendations/$id/acknowledge';
  static String dismissRecommendation(String id) =>
      '/api/v1/recommendations/$id/dismiss';

  // Devices
  static const String devices = '/api/v1/devices';
  static String device(String id) => '/api/v1/devices/$id';
  static String deviceActivate(String id) => '/api/v1/devices/$id/activate';
  static String deviceDeactivate(String id) => '/api/v1/devices/$id/deactivate';

  // Security
  static String farmSecurityEvents(String farmId) =>
      '/api/v1/farms/$farmId/security/events';
  static String securityEvent(String eventId) =>
      '/api/v1/security/events/$eventId';
  static String farmSecuritySettings(String farmId) =>
      '/api/v1/farms/$farmId/security/settings';

  // Subscriptions
  static const String mySubscription = '/api/v1/subscriptions/me';
  static const String subscriptionPlans = '/api/v1/subscriptions/plans';
  static const String myInvoices = '/api/v1/subscriptions/me/invoices';
  static const String myPayments = '/api/v1/subscriptions/me/payments';

  // Dashboard
  static const String farmerDashboard = '/api/v1/dashboard/farmer';
  static const String agronomistDashboard = '/api/v1/dashboard/agronomist';
  static const String priorityCases = '/api/v1/dashboard/priority-cases';

  // Agronomist
  static const String agronomistClients = '/api/v1/agronomist/clients';
  static const String agronomistClientsDetailed =
      '/api/v1/agronomist/clients/detailed';
  static const String agronomistSummary = '/api/v1/agronomist/summary';
  static const String agronomistVisits = '/api/v1/agronomist/visits';
  static String farmerAgronomist(String farmerId) =>
      '/api/v1/farmers/$farmerId/agronomist';

  // Activities
  static const String activities = '/api/v1/activities';

  // Analytics
  static const String parcelComparison = '/api/v1/analytics/parcels/compare';
  static String waterConsumptionReport(String zoneId) =>
      '/api/v1/zones/$zoneId/irrigation/reports/water-consumption';
  static String securityEventsExport(String farmId) =>
      '/api/v1/farms/$farmId/security/events/export';
  static const String activityLog = '/api/v1/activity-log';

  // Onboarding
  static const String onboardingStatus = '/api/v1/onboarding/status';
  static const String onboardingComplete = '/api/v1/onboarding/complete';
}
