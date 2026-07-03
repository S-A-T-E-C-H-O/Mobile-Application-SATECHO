import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';

class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._client);

  final ApiClient _client;

  Future<FarmerKpis> getFarmerKpis() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.farmerDashboard,
    );
    final d = response.data ?? {};
    final farms = d['farms'] as List<dynamic>?;
    final firstFarmName = farms != null && farms.isNotEmpty
        ? (farms.first as Map<String, dynamic>)['name'] as String?
        : null;

    return FarmerKpis(
      totalZones: (d['totalZones'] as num?)?.toInt() ?? 0,
      onlineDevices: (d['onlineDevices'] as num?)?.toInt() ?? 0,
      offlineDevices: (d['offlineDevices'] as num?)?.toInt() ?? 0,
      criticalAlerts: (d['activeAlertCount'] as num?)?.toInt() ??
          (d['errorDevices'] as num?)?.toInt() ??
          0,
      firstFarmName: firstFarmName,
      avgMoisture7d: (d['avgMoisture7d'] as num?)?.toDouble(),
      avgEc7d: (d['avgEc7d'] as num?)?.toDouble(),
      weeklyIrrigationHours: (d['weeklyIrrigationHours'] as num?)?.toDouble(),
      criticalMoisture: d['criticalMoisture'] as bool? ?? false,
    );
  }
}
