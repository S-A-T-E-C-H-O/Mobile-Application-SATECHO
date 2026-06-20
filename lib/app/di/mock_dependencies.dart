import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:satecho_mobile/core/network/api_client.dart' show ApiClient;
import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';
import 'package:satecho_mobile/features/activity_log/domain/use_cases/save_activity_offline.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_repository.dart';
import 'package:satecho_mobile/features/activity_log/data/activity_remote_data_source.dart';
import 'package:satecho_mobile/features/activity_log/data/activity_repository_impl.dart';
import 'package:satecho_mobile/features/activity_log/data/mock_activity_repository.dart';
import 'package:satecho_mobile/features/activity_log/presentation/controllers/activity_flow_controller.dart';
import 'package:satecho_mobile/features/advisory/domain/use_cases/create_agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/use_cases/get_recommendations.dart';
import 'package:satecho_mobile/features/advisory/domain/use_cases/mark_recommendation_completed.dart';
import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/data/recommendation_remote_data_source.dart';
import 'package:satecho_mobile/features/advisory/data/agronomist_recommendation_repository_impl.dart';
import 'package:satecho_mobile/features/advisory/data/mock_agronomist_recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/data/mock_recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/data/recommendation_repository_impl.dart';
import 'package:satecho_mobile/features/advisory/presentation/controllers/new_recommendation_controller.dart';
import 'package:satecho_mobile/features/advisory/presentation/controllers/recommendations_controller.dart';
import 'package:satecho_mobile/features/analytics/domain/use_cases/get_farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/domain/dashboard_repository.dart';
import 'package:satecho_mobile/features/analytics/data/dashboard_remote_data_source.dart';
import 'package:satecho_mobile/features/analytics/data/dashboard_repository_impl.dart';
import 'package:satecho_mobile/features/analytics/data/mock_dashboard_repository.dart';
import 'package:satecho_mobile/features/analytics/presentation/controllers/dashboard_controller.dart';
import 'package:satecho_mobile/features/auth/data/auth_local_data_source.dart';
import 'package:satecho_mobile/features/auth/data/auth_remote_data_source.dart';
import 'package:satecho_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/verify_email_controller.dart';
import 'package:satecho_mobile/features/billing/domain/use_cases/get_current_subscription.dart';
import 'package:satecho_mobile/features/billing/domain/subscription_repository.dart';
import 'package:satecho_mobile/features/billing/data/subscription_remote_data_source.dart';
import 'package:satecho_mobile/features/billing/data/mock_subscription_repository.dart';
import 'package:satecho_mobile/features/billing/data/subscription_repository_impl.dart';
import 'package:satecho_mobile/features/billing/presentation/controllers/billing_controller.dart';
import 'package:satecho_mobile/features/devices/domain/use_cases/get_all_devices.dart';
import 'package:satecho_mobile/features/devices/domain/device_repository.dart';
import 'package:satecho_mobile/features/devices/data/device_remote_data_source.dart';
import 'package:satecho_mobile/features/devices/data/device_repository_impl.dart';
import 'package:satecho_mobile/features/devices/data/mock_device_repository.dart';
import 'package:satecho_mobile/features/devices/presentation/controllers/devices_controller.dart';
import 'package:satecho_mobile/features/farms/domain/use_cases/get_assigned_client_detail.dart';
import 'package:satecho_mobile/features/farms/domain/use_cases/get_assigned_clients.dart';
import 'package:satecho_mobile/features/farms/domain/farm_repository.dart';
import 'package:satecho_mobile/features/farms/data/farm_remote_data_source.dart';
import 'package:satecho_mobile/features/farms/data/farm_repository_impl.dart';
import 'package:satecho_mobile/features/farms/data/mock_farm_repository.dart';
import 'package:satecho_mobile/features/farms/presentation/controllers/clients_controller.dart';
import 'package:satecho_mobile/features/farms/presentation/controllers/estate_detail_controller.dart';
import 'package:satecho_mobile/features/field_visits/domain/use_cases/get_scheduled_visits.dart';
import 'package:satecho_mobile/features/field_visits/domain/use_cases/save_field_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_repository.dart';
import 'package:satecho_mobile/features/field_visits/data/field_visit_remote_data_source.dart';
import 'package:satecho_mobile/features/field_visits/data/field_visit_repository_impl.dart';
import 'package:satecho_mobile/features/field_visits/data/mock_field_visit_repository.dart';
import 'package:satecho_mobile/features/field_visits/presentation/controllers/agenda_controller.dart';
import 'package:satecho_mobile/features/field_visits/presentation/controllers/field_visit_controller.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/get_current_irrigation_session.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/get_irrigation_history.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/get_upcoming_irrigations.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/start_irrigation.dart';
import 'package:satecho_mobile/features/irrigation/domain/use_cases/stop_irrigation.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_repository.dart';
import 'package:satecho_mobile/features/irrigation/data/irrigation_remote_data_source.dart';
import 'package:satecho_mobile/features/irrigation/data/irrigation_repository_impl.dart';
import 'package:satecho_mobile/features/irrigation/data/mock_irrigation_repository.dart';
import 'package:satecho_mobile/features/irrigation/presentation/controllers/irrigation_controller.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/get_active_alerts.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/get_agronomist_alerts.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/resolve_alert.dart';
import 'package:satecho_mobile/features/notifications/domain/agronomist_alert_repository.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_repository.dart';
import 'package:satecho_mobile/features/notifications/data/alert_remote_data_source.dart';
import 'package:satecho_mobile/features/notifications/data/alert_repository_impl.dart';
import 'package:satecho_mobile/features/notifications/data/alert_remote_data_source.dart' show AlertRemoteDataSource;
import 'package:satecho_mobile/features/notifications/data/agronomist_alert_repository_impl.dart';
import 'package:satecho_mobile/features/notifications/data/mock_agronomist_alert_repository.dart';
import 'package:satecho_mobile/features/notifications/data/mock_alert_repository.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/agronomist_alerts_controller.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/alerts_controller.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/notification_preferences_controller.dart';
import 'package:satecho_mobile/features/onboarding/domain/onboarding_repository.dart';
import 'package:satecho_mobile/features/onboarding/data/onboarding_remote_data_source.dart';
import 'package:satecho_mobile/features/onboarding/data/mock_onboarding_repository.dart';
import 'package:satecho_mobile/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:satecho_mobile/features/onboarding/presentation/controllers/onboarding_wizard_controller.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/use_cases/get_security_events.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/security_event_repository.dart';
import 'package:satecho_mobile/features/perimeter_security/data/security_event_remote_data_source.dart';
import 'package:satecho_mobile/features/perimeter_security/data/mock_security_event_repository.dart';
import 'package:satecho_mobile/features/perimeter_security/data/security_event_repository_impl.dart';
import 'package:satecho_mobile/features/perimeter_security/presentation/controllers/perimeter_security_controller.dart';
import 'package:satecho_mobile/features/quick_reports/domain/use_cases/get_quick_reports.dart';
import 'package:satecho_mobile/features/quick_reports/domain/quick_report_repository.dart';
import 'package:satecho_mobile/features/quick_reports/data/quick_report_remote_data_source.dart';
import 'package:satecho_mobile/features/quick_reports/data/mock_quick_report_repository.dart';
import 'package:satecho_mobile/features/quick_reports/data/quick_report_repository_impl.dart';
import 'package:satecho_mobile/features/quick_reports/presentation/controllers/quick_reports_controller.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/use_cases/get_plot_by_id.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/use_cases/get_plots.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_repository.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/plot_remote_data_source.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/mock_plot_repository.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/plot_repository_impl.dart';
import 'package:satecho_mobile/features/soil_monitoring/presentation/controllers/plots_controller.dart';
import 'package:satecho_mobile/features/user_profile/domain/use_cases/get_agronomist_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/use_cases/get_user_profile.dart';
import 'package:satecho_mobile/features/user_profile/domain/use_cases/logout_user.dart';
import 'package:satecho_mobile/features/user_profile/domain/agronomist_profile_repository.dart';
import 'package:satecho_mobile/features/user_profile/domain/user_profile_repository.dart';
import 'package:satecho_mobile/features/user_profile/data/user_profile_remote_data_source.dart';
import 'package:satecho_mobile/features/user_profile/data/agronomist_profile_repository_impl.dart';
import 'package:satecho_mobile/features/user_profile/data/mock_agronomist_profile_repository.dart';
import 'package:satecho_mobile/features/user_profile/data/mock_user_profile_repository.dart';
import 'package:satecho_mobile/features/user_profile/data/user_profile_repository_impl.dart';
import 'package:satecho_mobile/features/user_profile/presentation/controllers/agronomist_profile_controller.dart';
import 'package:satecho_mobile/features/user_profile/presentation/controllers/profile_controller.dart';
import 'package:satecho_mobile/features/zones/domain/use_cases/get_zone_by_id.dart';
import 'package:satecho_mobile/features/zones/domain/use_cases/get_zones_by_farm.dart';
import 'package:satecho_mobile/features/zones/domain/zone_repository.dart';
import 'package:satecho_mobile/features/zones/data/zone_remote_data_source.dart';
import 'package:satecho_mobile/features/zones/data/mock_zone_repository.dart';
import 'package:satecho_mobile/features/zones/data/zone_repository_impl.dart';
import 'package:satecho_mobile/features/zones/presentation/controllers/zone_analysis_controller.dart';

class AppDependencies {
  AppDependencies.mock()
      : realtime = RealtimeService(),
        plotRepository = MockPlotRepository(),
        zoneRepository = MockZoneRepository(),
        irrigationRepository = MockIrrigationRepository(),
        alertRepository = MockAlertRepository(),
        agronomistAlertRepository = MockAgronomistAlertRepository(),
        recommendationRepository = MockRecommendationRepository(),
        agronomistRecommendationRepository =
        MockAgronomistRecommendationRepository(),
        activityRepository = MockActivityRepository(),
        userProfileRepository = MockUserProfileRepository(),
        agronomistProfileRepository = MockAgronomistProfileRepository(),
        deviceRepository = MockDeviceRepository(),
        subscriptionRepository = MockSubscriptionRepository(),
        securityEventRepository = MockSecurityEventRepository(),
        onboardingRepository = MockOnboardingRepository(),
        fieldVisitRepository = MockFieldVisitRepository(),
        quickReportRepository = MockQuickReportRepository(),
        _apiClient = null,
        _authRepository = null {
    farmRepository = MockFarmRepository(zoneRepository);
  }

  AppDependencies.real() : this._fromShared(_buildSharedInfra());

  AppDependencies._fromShared(_SharedInfra infra)
      : realtime = RealtimeService(),
        plotRepository =
        PlotRepositoryImpl(PlotRemoteDataSource(infra.client)),
        zoneRepository =
        ZoneRepositoryImpl(ZoneRemoteDataSource(infra.client)),
        irrigationRepository = IrrigationRepositoryImpl(
          IrrigationRemoteDataSource(infra.client),
          infra.client,
        ),
        alertRepository =
        AlertRepositoryImpl(AlertRemoteDataSource(infra.client)),
        agronomistAlertRepository =
        AgronomistAlertRepositoryImpl(AlertRemoteDataSource(infra.client)),
        recommendationRepository = RecommendationRepositoryImpl(
          RecommendationRemoteDataSource(infra.client),
        ),
        agronomistRecommendationRepository =
        AgronomistRecommendationRepositoryImpl(
          RecommendationRemoteDataSource(infra.client),
        ),
        activityRepository =
        ActivityRepositoryImpl(ActivityRemoteDataSource(infra.client)),
        userProfileRepository = UserProfileRepositoryImpl(
          remote: UserProfileRemoteDataSource(infra.client),
          local: AuthLocalDataSource(infra.storage),
        ),
        agronomistProfileRepository = AgronomistProfileRepositoryImpl(
          UserProfileRemoteDataSource(infra.client),
        ),
        deviceRepository = DeviceRepositoryImpl(
          DeviceRemoteDataSource(infra.client),
          infra.client,
        ),
        subscriptionRepository = SubscriptionRepositoryImpl(
          SubscriptionRemoteDataSource(infra.client),
        ),
        securityEventRepository = SecurityEventRepositoryImpl(
          SecurityEventRemoteDataSource(infra.client),
          infra.client,
        ),
        onboardingRepository = OnboardingRepositoryImpl(
          OnboardingRemoteDataSource(infra.client),
        ),
        fieldVisitRepository =
        FieldVisitRepositoryImpl(FieldVisitRemoteDataSource(infra.client)),
        quickReportRepository = QuickReportRepositoryImpl(
          QuickReportRemoteDataSource(infra.client),
        ),
        _apiClient = infra.client,
        _authRepository = AuthRepositoryImpl(
          remote: AuthRemoteDataSource(infra.client),
          local: AuthLocalDataSource(infra.storage),
        ) {
    final zoneRemote = ZoneRemoteDataSource(infra.client);
    farmRepository = FarmRepositoryImpl(
      FarmRemoteDataSource(infra.client),
      zoneRemote,
    );
  }

  static _SharedInfra _buildSharedInfra() {
    const secureStorage = FlutterSecureStorage();
    const storage = TokenStorage(secureStorage);
    final client = ApiClient(tokenStorage: storage);
    return _SharedInfra(storage: storage, client: client);
  }

  final RealtimeService realtime;
  final PlotRepository plotRepository;
  final ZoneRepository zoneRepository;
  late final FarmRepository farmRepository;
  final IrrigationRepository irrigationRepository;
  final AlertRepository alertRepository;
  final AgronomistAlertRepository agronomistAlertRepository;
  final RecommendationRepository recommendationRepository;
  final AgronomistRecommendationRepository agronomistRecommendationRepository;
  final ActivityRepository activityRepository;
  final UserProfileRepository userProfileRepository;
  final AgronomistProfileRepository agronomistProfileRepository;
  final DeviceRepository deviceRepository;
  final SubscriptionRepository subscriptionRepository;
  final SecurityEventRepository securityEventRepository;
  final OnboardingRepository onboardingRepository;
  final FieldVisitRepository fieldVisitRepository;
  final QuickReportRepository quickReportRepository;

  final ApiClient? _apiClient;
  final AuthRepositoryImpl? _authRepository;
  AuthRepositoryImpl get authRepository {
    assert(_authRepository != null, 'authRepository only available in real mode');
    return _authRepository!;
  }

  GetPlots get getPlots => GetPlots(plotRepository);
  GetPlotById get getPlotById => GetPlotById(plotRepository);
  GetZonesByFarm get getZonesByFarm => GetZonesByFarm(zoneRepository);
  GetZoneById get getZoneById => GetZoneById(zoneRepository);

  GetAssignedClients get getAssignedClients =>
      GetAssignedClients(farmRepository);

  GetAssignedClientDetail get getAssignedClientDetail =>
      GetAssignedClientDetail(farmRepository);

  GetCurrentIrrigationSession get getCurrentIrrigationSession =>
      GetCurrentIrrigationSession(irrigationRepository);

  GetUpcomingIrrigations get getUpcomingIrrigations =>
      GetUpcomingIrrigations(irrigationRepository);

  StartIrrigation get startIrrigation => StartIrrigation(irrigationRepository);
  StopIrrigation get stopIrrigation => StopIrrigation(irrigationRepository);
  GetIrrigationHistory get getIrrigationHistory =>
      GetIrrigationHistory(irrigationRepository);

  GetActiveAlerts get getActiveAlerts => GetActiveAlerts(alertRepository);
  GetAgronomistAlerts get getAgronomistAlerts =>
      GetAgronomistAlerts(agronomistAlertRepository);

  ResolveAlert get resolveAlert => ResolveAlert(alertRepository);

  GetRecommendations get getRecommendations =>
      GetRecommendations(recommendationRepository);

  MarkRecommendationCompleted get markRecommendationCompleted =>
      MarkRecommendationCompleted(recommendationRepository);

  CreateAgronomistRecommendation get createAgronomistRecommendation =>
      CreateAgronomistRecommendation(agronomistRecommendationRepository);

  SaveActivityOffline get saveActivityOffline =>
      SaveActivityOffline(activityRepository);

  GetScheduledVisits get getScheduledVisits =>
      GetScheduledVisits(fieldVisitRepository);

  SaveFieldVisit get saveFieldVisit => SaveFieldVisit(fieldVisitRepository);

  GetQuickReports get getQuickReports => GetQuickReports(quickReportRepository);

  GetAllDevices get getAllDevices => GetAllDevices(deviceRepository);

  GetUserProfile get getUserProfile => GetUserProfile(userProfileRepository);
  GetAgronomistProfile get getAgronomistProfile =>
      GetAgronomistProfile(agronomistProfileRepository);

  LogoutUser get logoutUser => LogoutUser(userProfileRepository);

  GetSecurityEvents get getSecurityEvents =>
      GetSecurityEvents(securityEventRepository);

  AuthController createAuthController() => AuthController(
    authRepository: _authRepository,
  );

  VerifyEmailController createVerifyEmailController(String email) =>
      VerifyEmailController(
        email: email,
        authRepository: _authRepository,
      );

  OnboardingWizardController createOnboardingWizardController() =>
      OnboardingWizardController(repository: onboardingRepository);

  NotificationPreferencesController createNotificationPreferencesController() {
    final client = _apiClient;
    return NotificationPreferencesController(
      remote: client != null ? AlertRemoteDataSource(client) : null,
    );
  }

  BillingController createBillingController() {
    final client = _apiClient;
    return BillingController(
      GetCurrentSubscription(subscriptionRepository),
      remote: client != null ? SubscriptionRemoteDataSource(client) : null,
    );
  }

  DashboardController createDashboardController() {
    final client = _apiClient;
    final DashboardRepository dashRepo = _authRepository != null
        ? DashboardRepositoryImpl(
      plotRepository: plotRepository,
      irrigationRepository: irrigationRepository,
      alertRepository: alertRepository,
      remote: client != null ? DashboardRemoteDataSource(client) : null,
    )
        : MockDashboardRepository(
      plotRepository: plotRepository,
      irrigationRepository: irrigationRepository,
      alertRepository: alertRepository,
    );
    return DashboardController(GetFarmerDashboard(dashRepo));
  }

  PlotsController createPlotsController() => PlotsController(getPlots);

  DevicesController createDevicesController() =>
      DevicesController(getAllDevices);

  ClientsController createClientsController() =>
      ClientsController(getAssignedClients);

  EstateDetailController createEstateDetailController() =>
      EstateDetailController(getAssignedClientDetail);

  ZoneAnalysisController createZoneAnalysisController() =>
      ZoneAnalysisController(getZoneById);

  IrrigationController createIrrigationController() {
    return IrrigationController(
      getPlots: getPlots,
      getSession: getCurrentIrrigationSession,
      startIrrigation: startIrrigation,
      stopIrrigation: stopIrrigation,
      getHistory: getIrrigationHistory,
      realtime: realtime,
    );
  }

  AlertsController createAlertsController() =>
      AlertsController(getActiveAlerts, resolveAlert);

  AgronomistAlertsController createAgronomistAlertsController() =>
      AgronomistAlertsController(getAgronomistAlerts);

  RecommendationsController createRecommendationsController() {
    return RecommendationsController(
      getRecommendations,
      markRecommendationCompleted,
    );
  }

  NewRecommendationController createNewRecommendationController() =>
      NewRecommendationController(createAgronomistRecommendation);

  ActivityFlowController createActivityFlowController() =>
      ActivityFlowController(saveActivityOffline);

  AgendaController createAgendaController() =>
      AgendaController(getScheduledVisits, fieldVisitRepository);

  FieldVisitController createFieldVisitController() =>
      FieldVisitController(saveFieldVisit);

  QuickReportsController createQuickReportsController() =>
      QuickReportsController(getQuickReports);

  ProfileController createProfileController() =>
      ProfileController(getUserProfile, logoutUser);

  AgronomistProfileController createAgronomistProfileController() =>
      AgronomistProfileController(getAgronomistProfile);

  PerimeterSecurityController createPerimeterSecurityController() {
    return PerimeterSecurityController(
      getSecurityEvents: getSecurityEvents,
      realtime: realtime,
    );
  }
}

class _SharedInfra {
  const _SharedInfra({required this.storage, required this.client});
  final TokenStorage storage;
  final ApiClient client;
}

class AppDependenciesScope extends InheritedWidget {
  const AppDependenciesScope({
    required this.dependencies,
    required super.child,
    super.key,
  });

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final element =
    context.getElementForInheritedWidgetOfExactType<AppDependenciesScope>();
    final scope = element?.widget as AppDependenciesScope?;
    assert(scope != null, 'AppDependenciesScope not found');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppDependenciesScope oldWidget) {
    return dependencies != oldWidget.dependencies;
  }
}
