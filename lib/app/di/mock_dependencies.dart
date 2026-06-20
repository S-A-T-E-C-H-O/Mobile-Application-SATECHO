import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/network/api_client.dart' show ApiClient;
import '../../core/realtime/realtime_placeholder.dart';
import '../../core/storage/token_storage.dart';
import '../../features/activity_log/application/use_cases/save_activity_offline.dart';
import '../../features/activity_log/domain/repositories/activity_repository.dart';
import '../../features/activity_log/infrastructure/data_sources/remote/activity_remote_data_source.dart';
import '../../features/activity_log/infrastructure/repositories/activity_repository_impl.dart';
import '../../features/activity_log/infrastructure/repositories/mock_activity_repository.dart';
import '../../features/activity_log/presentation/controllers/activity_flow_controller.dart';
import '../../features/advisory/application/use_cases/create_agronomist_recommendation.dart';
import '../../features/advisory/application/use_cases/get_recommendations.dart';
import '../../features/advisory/application/use_cases/mark_recommendation_completed.dart';
import '../../features/advisory/domain/repositories/agronomist_recommendation_repository.dart';
import '../../features/advisory/domain/repositories/recommendation_repository.dart';
import '../../features/advisory/infrastructure/data_sources/remote/recommendation_remote_data_source.dart';
import '../../features/advisory/infrastructure/repositories/agronomist_recommendation_repository_impl.dart';
import '../../features/advisory/infrastructure/repositories/mock_agronomist_recommendation_repository.dart';
import '../../features/advisory/infrastructure/repositories/mock_recommendation_repository.dart';
import '../../features/advisory/infrastructure/repositories/recommendation_repository_impl.dart';
import '../../features/advisory/presentation/controllers/new_recommendation_controller.dart';
import '../../features/advisory/presentation/controllers/recommendations_controller.dart';
import '../../features/analytics/application/use_cases/get_farmer_dashboard.dart';
import '../../features/analytics/domain/repositories/dashboard_repository.dart';
import '../../features/analytics/infrastructure/data_sources/remote/dashboard_remote_data_source.dart';
import '../../features/analytics/infrastructure/repositories/dashboard_repository_impl.dart';
import '../../features/analytics/infrastructure/repositories/mock_dashboard_repository.dart';
import '../../features/analytics/presentation/controllers/dashboard_controller.dart';
import '../../features/auth/infrastructure/data_sources/local/auth_local_data_source.dart';
import '../../features/auth/infrastructure/data_sources/remote/auth_remote_data_source.dart';
import '../../features/auth/infrastructure/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/verify_email_controller.dart';
import '../../features/billing/application/use_cases/get_current_subscription.dart';
import '../../features/billing/domain/repositories/subscription_repository.dart';
import '../../features/billing/infrastructure/data_sources/remote/subscription_remote_data_source.dart';
import '../../features/billing/infrastructure/repositories/mock_subscription_repository.dart';
import '../../features/billing/infrastructure/repositories/subscription_repository_impl.dart';
import '../../features/billing/presentation/controllers/billing_controller.dart';
import '../../features/devices/application/use_cases/get_all_devices.dart';
import '../../features/devices/domain/repositories/device_repository.dart';
import '../../features/devices/infrastructure/data_sources/remote/device_remote_data_source.dart';
import '../../features/devices/infrastructure/repositories/device_repository_impl.dart';
import '../../features/devices/infrastructure/repositories/mock_device_repository.dart';
import '../../features/devices/presentation/controllers/devices_controller.dart';
import '../../features/farms/application/use_cases/get_assigned_client_detail.dart';
import '../../features/farms/application/use_cases/get_assigned_clients.dart';
import '../../features/farms/domain/repositories/farm_repository.dart';
import '../../features/farms/infrastructure/data_sources/remote/farm_remote_data_source.dart';
import '../../features/farms/infrastructure/repositories/farm_repository_impl.dart';
import '../../features/farms/infrastructure/repositories/mock_farm_repository.dart';
import '../../features/farms/presentation/controllers/clients_controller.dart';
import '../../features/farms/presentation/controllers/estate_detail_controller.dart';
import '../../features/field_visits/application/use_cases/get_scheduled_visits.dart';
import '../../features/field_visits/application/use_cases/save_field_visit.dart';
import '../../features/field_visits/domain/repositories/field_visit_repository.dart';
import '../../features/field_visits/infrastructure/data_sources/remote/field_visit_remote_data_source.dart';
import '../../features/field_visits/infrastructure/repositories/field_visit_repository_impl.dart';
import '../../features/field_visits/infrastructure/repositories/mock_field_visit_repository.dart';
import '../../features/field_visits/presentation/controllers/agenda_controller.dart';
import '../../features/field_visits/presentation/controllers/field_visit_controller.dart';
import '../../features/irrigation/application/use_cases/get_current_irrigation_session.dart';
import '../../features/irrigation/application/use_cases/get_irrigation_history.dart';
import '../../features/irrigation/application/use_cases/get_upcoming_irrigations.dart';
import '../../features/irrigation/application/use_cases/start_irrigation.dart';
import '../../features/irrigation/application/use_cases/stop_irrigation.dart';
import '../../features/irrigation/domain/repositories/irrigation_repository.dart';
import '../../features/irrigation/infrastructure/data_sources/remote/irrigation_remote_data_source.dart';
import '../../features/irrigation/infrastructure/repositories/irrigation_repository_impl.dart';
import '../../features/irrigation/infrastructure/repositories/mock_irrigation_repository.dart';
import '../../features/irrigation/presentation/controllers/irrigation_controller.dart';
import '../../features/notifications/application/use_cases/get_active_alerts.dart';
import '../../features/notifications/application/use_cases/get_agronomist_alerts.dart';
import '../../features/notifications/application/use_cases/resolve_alert.dart';
import '../../features/notifications/domain/repositories/agronomist_alert_repository.dart';
import '../../features/notifications/domain/repositories/alert_repository.dart';
import '../../features/notifications/infrastructure/data_sources/remote/alert_remote_data_source.dart';
import '../../features/notifications/infrastructure/repositories/alert_repository_impl.dart';
import '../../features/notifications/infrastructure/data_sources/remote/alert_remote_data_source.dart' show AlertRemoteDataSource;
import '../../features/notifications/infrastructure/repositories/agronomist_alert_repository_impl.dart';
import '../../features/notifications/infrastructure/repositories/mock_agronomist_alert_repository.dart';
import '../../features/notifications/infrastructure/repositories/mock_alert_repository.dart';
import '../../features/notifications/presentation/controllers/agronomist_alerts_controller.dart';
import '../../features/notifications/presentation/controllers/alerts_controller.dart';
import '../../features/notifications/presentation/controllers/notification_preferences_controller.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/infrastructure/data_sources/remote/onboarding_remote_data_source.dart';
import '../../features/onboarding/infrastructure/repositories/mock_onboarding_repository.dart';
import '../../features/onboarding/infrastructure/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/presentation/controllers/onboarding_wizard_controller.dart';
import '../../features/perimeter_security/application/use_cases/get_security_events.dart';
import '../../features/perimeter_security/domain/repositories/security_event_repository.dart';
import '../../features/perimeter_security/infrastructure/data_sources/remote/security_event_remote_data_source.dart';
import '../../features/perimeter_security/infrastructure/repositories/mock_security_event_repository.dart';
import '../../features/perimeter_security/infrastructure/repositories/security_event_repository_impl.dart';
import '../../features/perimeter_security/presentation/controllers/perimeter_security_controller.dart';
import '../../features/quick_reports/application/use_cases/get_quick_reports.dart';
import '../../features/quick_reports/domain/repositories/quick_report_repository.dart';
import '../../features/quick_reports/infrastructure/data_sources/remote/quick_report_remote_data_source.dart';
import '../../features/quick_reports/infrastructure/repositories/mock_quick_report_repository.dart';
import '../../features/quick_reports/infrastructure/repositories/quick_report_repository_impl.dart';
import '../../features/quick_reports/presentation/controllers/quick_reports_controller.dart';
import '../../features/soil_monitoring/application/use_cases/get_plot_by_id.dart';
import '../../features/soil_monitoring/application/use_cases/get_plots.dart';
import '../../features/soil_monitoring/domain/repositories/plot_repository.dart';
import '../../features/soil_monitoring/infrastructure/data_sources/remote/plot_remote_data_source.dart';
import '../../features/soil_monitoring/infrastructure/repositories/mock_plot_repository.dart';
import '../../features/soil_monitoring/infrastructure/repositories/plot_repository_impl.dart';
import '../../features/soil_monitoring/presentation/controllers/plots_controller.dart';
import '../../features/user_profile/application/use_cases/get_agronomist_profile.dart';
import '../../features/user_profile/application/use_cases/get_user_profile.dart';
import '../../features/user_profile/application/use_cases/logout_user.dart';
import '../../features/user_profile/domain/repositories/agronomist_profile_repository.dart';
import '../../features/user_profile/domain/repositories/user_profile_repository.dart';
import '../../features/user_profile/infrastructure/data_sources/remote/user_profile_remote_data_source.dart';
import '../../features/user_profile/infrastructure/repositories/agronomist_profile_repository_impl.dart';
import '../../features/user_profile/infrastructure/repositories/mock_agronomist_profile_repository.dart';
import '../../features/user_profile/infrastructure/repositories/mock_user_profile_repository.dart';
import '../../features/user_profile/infrastructure/repositories/user_profile_repository_impl.dart';
import '../../features/user_profile/presentation/controllers/agronomist_profile_controller.dart';
import '../../features/user_profile/presentation/controllers/profile_controller.dart';
import '../../features/zones/application/use_cases/get_zone_by_id.dart';
import '../../features/zones/application/use_cases/get_zones_by_farm.dart';
import '../../features/zones/domain/repositories/zone_repository.dart';
import '../../features/zones/infrastructure/data_sources/remote/zone_remote_data_source.dart';
import '../../features/zones/infrastructure/repositories/mock_zone_repository.dart';
import '../../features/zones/infrastructure/repositories/zone_repository_impl.dart';
import '../../features/zones/presentation/controllers/zone_analysis_controller.dart';

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
