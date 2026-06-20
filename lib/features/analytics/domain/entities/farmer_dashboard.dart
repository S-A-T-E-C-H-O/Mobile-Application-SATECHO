import '../../../irrigation/domain/entities/upcoming_irrigation.dart';
import '../../../notifications/domain/entities/farm_alert.dart';
import '../../../soil_monitoring/domain/entities/plot.dart';
import 'weather_summary.dart';

class FarmerKpis {
  const FarmerKpis({
    required this.totalZones,
    required this.onlineDevices,
    required this.offlineDevices,
    required this.criticalAlerts,
    this.firstFarmName,
  });

  final int totalZones;
  final int onlineDevices;
  final int offlineDevices;
  final int criticalAlerts;
  final String? firstFarmName;
}

class FarmerDashboard {
  const FarmerDashboard({
    required this.greeting,
    required this.farmName,
    required this.weather,
    required this.plots,
    required this.upcomingIrrigations,
    required this.activeAlerts,
    this.kpis,
  });

  final String greeting;
  final String farmName;
  final WeatherSummary weather;
  final List<Plot> plots;
  final List<UpcomingIrrigation> upcomingIrrigations;
  final List<FarmAlert> activeAlerts;
  final FarmerKpis? kpis;
}
