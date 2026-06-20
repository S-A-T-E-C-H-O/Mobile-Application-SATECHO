import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../../domain/entities/farmer_dashboard.dart';

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
      criticalAlerts: (d['errorDevices'] as num?)?.toInt() ?? 0,
      firstFarmName: firstFarmName,
    );
  }
}
