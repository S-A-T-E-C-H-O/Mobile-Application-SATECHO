import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_settings.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/repositories/security_event_repository.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/data_sources/remote/security_event_remote_data_source.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/models/security_event_model.dart';

class SecurityEventRepositoryImpl implements SecurityEventRepository {
  SecurityEventRepositoryImpl(this._remote, this._client);

  final SecurityEventRemoteDataSource _remote;
  final ApiClient _client;

  String? _cachedFarmId;

  Future<String> _resolveFarmId() async {
    if (_cachedFarmId != null) return _cachedFarmId!;
    final farmsResponse = await _client.get<List<dynamic>>(ApiConstants.farms);
    final farms = farmsResponse.data as List<dynamic>;
    if (farms.isEmpty) throw Exception('No farms found');
    _cachedFarmId = (farms.first as Map<String, dynamic>)['id'].toString();
    return _cachedFarmId!;
  }

  @override
  Future<List<SecurityEvent>> getSecurityEvents() async {
    try {
      final farmId = await _resolveFarmId();
      final models = await _remote.getSecurityEvents(farmId);
      return models.map((m) => _toDomain(m)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<int>?> exportCsv() async {
    try {
      final farmId = await _resolveFarmId();
      final response =
          await _client.getBytes(ApiConstants.securityEventsExport(farmId));
      return response.data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SecuritySettings> getSettings() async {
    final farmId = await _resolveFarmId();
    final model = await _remote.getSettings(farmId);
    return SecuritySettings(
      id: model.id,
      farmId: model.farmId,
      motionSensitivity: model.motionSensitivity,
      alertMode: model.alertMode,
      detectionScheduleStart: model.detectionScheduleStart,
      detectionScheduleEnd: model.detectionScheduleEnd,
      notificationContacts: model.notificationContacts,
      disabledZoneIds: model.disabledZoneIds,
    );
  }

  @override
  Future<void> updateSettings(Map<String, dynamic> data) async {
    final farmId = await _resolveFarmId();
    await _remote.updateSettings(farmId, data);
  }

  @override
  Future<void> toggleZoneDetection(String zoneId, bool enabled) async {
    final farmId = await _resolveFarmId();
    await _remote.toggleZoneDetection(farmId, zoneId, enabled);
  }

  @visibleForTesting
  static SecurityEvent toDomainForTesting(SecurityEventModel m) => _toDomain(m);

  static SecurityEvent _toDomain(SecurityEventModel m) {
    final zoneName = m.locationDescription ?? 'Unknown zone';
    final title = switch (m.classification.toUpperCase()) {
      'PERSON' => 'Person detected in $zoneName',
      'ANIMAL' => 'Animal movement in $zoneName',
      'WIND' => 'Wind-triggered movement in $zoneName',
      _ => 'Movement detected in $zoneName',
    };
    return SecurityEvent(
      id: m.id.toString(),
      title: title,
      zoneId: m.id.toString(),
      zoneName: zoneName,
      createdAt: m.detectedAt,
      classification: m.classification.toUpperCase(),
    );
  }
}
