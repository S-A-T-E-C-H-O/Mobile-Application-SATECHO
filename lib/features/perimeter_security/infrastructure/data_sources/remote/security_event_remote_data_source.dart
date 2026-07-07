import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/models/security_event_model.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/models/security_settings_model.dart';

class SecurityEventRemoteDataSource {
  const SecurityEventRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<SecurityEventModel>> getSecurityEvents(String farmId) async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.farmSecurityEvents(farmId),
    );
    return (response.data as List<dynamic>)
        .map((e) => SecurityEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SecuritySettingsModel> getSettings(String farmId) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.farmSecuritySettings(farmId),
    );
    return SecuritySettingsModel.fromJson(response.data!);
  }

  Future<void> updateSettings(
    String farmId,
    Map<String, dynamic> data,
  ) async {
    await _client.put<void>(
      ApiConstants.farmSecuritySettings(farmId),
      data: data,
    );
  }

  Future<void> toggleZoneDetection(
    String farmId,
    String zoneId,
    bool enabled,
  ) async {
    await _client.put<void>(
      ApiConstants.farmSecuritySettingsZone(farmId, zoneId),
      data: {'enabled': enabled},
    );
  }
}
