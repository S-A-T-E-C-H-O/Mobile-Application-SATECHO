import 'package:satecho_mobile/features/irrigation/domain/irrigation_repository.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_repository.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_repository.dart';
import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/domain/weather_summary.dart';
import 'package:satecho_mobile/features/analytics/domain/dashboard_repository.dart';
import 'package:satecho_mobile/features/analytics/data/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required PlotRepository plotRepository,
    required IrrigationRepository irrigationRepository,
    required AlertRepository alertRepository,
    DashboardRemoteDataSource? remote,
  })  : _plotRepository = plotRepository,
        _irrigationRepository = irrigationRepository,
        _alertRepository = alertRepository,
        _remote = remote;

  final PlotRepository _plotRepository;
  final IrrigationRepository _irrigationRepository;
  final AlertRepository _alertRepository;
  final DashboardRemoteDataSource? _remote;

  @override
  Future<FarmerDashboard> getFarmerDashboard() async {
    final plotsFuture = _plotRepository.getPlots();
    final irrigationsFuture = _irrigationRepository.getUpcomingIrrigations();
    final alertsFuture = _alertRepository.getActiveAlerts();
    final kpisFuture = _remote?.getFarmerKpis();

    final plots = await plotsFuture;
    final irrigations = await irrigationsFuture;
    final alerts = await alertsFuture;

    FarmerKpis? kpis;
    try {
      kpis = await kpisFuture;
    } on Exception {
      // keep null if KPI fetch fails
    }

    final farmName = kpis?.firstFarmName ??
        (plots.isNotEmpty ? 'My Farm' : 'No farm');

    return FarmerDashboard(
      greeting: _greeting(),
      farmName: farmName,
      weather: const WeatherSummary(
        temperature: 24,
        condition: 'Partly cloudy',
        hasAlert: false,
      ),
      plots: plots.take(3).toList(),
      upcomingIrrigations: irrigations,
      activeAlerts: alerts,
      kpis: kpis,
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }
}
