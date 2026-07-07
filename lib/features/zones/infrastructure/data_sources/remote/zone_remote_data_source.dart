import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/zones/infrastructure/models/zone_model.dart';

class ZoneRemoteDataSource {
  const ZoneRemoteDataSource(this._client);

  final ApiClient _client;

  Future<String?> getMyFarmId() async {
    try {
      final response =
          await _client.get<List<dynamic>>(ApiConstants.farms);
      final farms = response.data as List<dynamic>;
      if (farms.isNotEmpty) {
        final first = farms.first as Map<String, dynamic>;
        return (first['id'] as num).toInt().toString();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<ZoneModel?> getZoneById(String zoneId) async {
    try {
      final response =
          await _client.get<Map<String, dynamic>>(ApiConstants.zone(zoneId));
      return ZoneModel.fromJson(response.data!);
    } catch (_) {
      return null;
    }
  }

  Future<List<ZoneModel>> getZonesByFarm(String farmId) async {
    try {
      final response =
          await _client.get<List<dynamic>>(ApiConstants.farmZones(farmId));
      return (response.data as List<dynamic>)
          .map((e) => ZoneModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> updateThresholds(
      String zoneId, Map<String, dynamic> data) async {
    await _client.patch<void>(ApiConstants.zoneThresholds(zoneId), data: data);
  }
}
