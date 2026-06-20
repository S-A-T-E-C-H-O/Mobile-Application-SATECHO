import '../../../irrigation/domain/repositories/irrigation_repository.dart';
import '../../../notifications/domain/repositories/alert_repository.dart';
import '../../../soil_monitoring/domain/repositories/plot_repository.dart';
import '../../domain/entities/farmer_dashboard.dart';
import '../../domain/entities/weather_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository({
    required PlotRepository plotRepository,
    required IrrigationRepository irrigationRepository,
    required AlertRepository alertRepository,
  })  : _plotRepository = plotRepository,
        _irrigationRepository = irrigationRepository,
        _alertRepository = alertRepository;

  final PlotRepository _plotRepository;
  final IrrigationRepository _irrigationRepository;
  final AlertRepository _alertRepository;

  @override
  Future<FarmerDashboard> getFarmerDashboard() async {
    final plots = await _plotRepository.getPlots();
    final irrigations = await _irrigationRepository.getUpcomingIrrigations();
    final alerts = await _alertRepository.getActiveAlerts();
    return FarmerDashboard(
      greeting: 'Good morning, Juan',
      farmName: 'El Porvenir',
      weather: const WeatherSummary(
        temperature: 24,
        condition: 'Partly cloudy',
        hasAlert: true,
      ),
      plots: plots.take(3).toList(),
      upcomingIrrigations: irrigations,
      activeAlerts: alerts,
      kpis: const FarmerKpis(
        totalZones: 4,
        onlineDevices: 6,
        offlineDevices: 1,
        criticalAlerts: 0,
      ),
    );
  }
}
