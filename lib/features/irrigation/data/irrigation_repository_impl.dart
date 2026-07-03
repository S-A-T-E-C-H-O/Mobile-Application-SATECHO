import 'dart:async';

import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_session.dart';
import 'package:satecho_mobile/features/irrigation/domain/upcoming_irrigation.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_repository.dart';
import 'package:satecho_mobile/features/irrigation/data/irrigation_remote_data_source.dart';
import 'package:satecho_mobile/features/irrigation/data/irrigation_session_model.dart';

class IrrigationRepositoryImpl implements IrrigationRepository {
  IrrigationRepositoryImpl(this._remote, this._client);

  final IrrigationRemoteDataSource _remote;
  final ApiClient _client;

  @override
  Future<IrrigationSession> getCurrentSession(String plotId) async {
    final model = await _remote.getActiveSession(plotId);
    if (model == null) return IrrigationSessionModel.idle(plotId);
    return model.toEntity();
  }

  @override
  Future<IrrigationSession> startIrrigation(
    String plotId,
    int durationMinutes,
  ) async {
    final model = await _remote.startIrrigation(plotId, durationMinutes);
    return model.toEntity();
  }

  @override
  Future<IrrigationSession> stopIrrigation(String plotId) async {
    final model = await _remote.stopIrrigation(plotId);
    return model.toEntity();
  }

  @override
  Future<List<UpcomingIrrigation>> getUpcomingIrrigations() async {
    final farmsResponse = await _client.get<List<dynamic>>(ApiConstants.farms);
    final farms = farmsResponse.data as List<dynamic>;

    final zoneEntries = await Future.wait(farms.map((f) async {
      final farmJson = f as Map<String, dynamic>;
      final farmId = farmJson['id'].toString();
      final zonesResponse = await _client.get<List<dynamic>>(
        ApiConstants.farmZones(farmId),
      );
      final zones = zonesResponse.data as List<dynamic>;
      return zones.map((z) => z as Map<String, dynamic>).toList();
    }));

    final allZones = zoneEntries.expand((zones) => zones).toList();

    final scheduleResults = await Future.wait(allZones.map((zone) async {
      final zoneId = zone['id'].toString();
      final zoneName = zone['name'] as String;
      try {
        final schedules = await _remote.getSchedules(zoneId);
        return schedules
            .where((s) => s.enabled && s.nextRunAt != null)
            .map((s) => UpcomingIrrigation(
                  id: s.id.toString(),
                  plotId: zoneId,
                  plotName: zoneName,
                  scheduleLabel: _scheduleLabel(s.nextRunAt!),
                  durationMinutes: s.durationMinutes,
                  highlighted: false,
                ));
      } catch (_) {
        return const <UpcomingIrrigation>[];
      }
    }));

    final result =
        scheduleResults.expand((irrigations) => irrigations).toList();

    if (result.isNotEmpty) {
      result[0] = result[0].copyWith(highlighted: true);
    }

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getHistory(String zoneId) async {
    final models = await _remote.getHistory(zoneId);
    return models
        .map((m) => {
              'id': m.id,
              'status': m.status,
              'startedAt': m.startedAt?.toIso8601String(),
              'durationMinutes': m.durationMinutes,
            })
        .toList();
  }

  String _scheduleLabel(DateTime dt) {
    final diff = dt.difference(DateTime.now());
    if (diff.inMinutes < 60) return 'in ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'in ${diff.inHours}h';
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'tomorrow';
    return 'in ${diff.inDays} days';
  }
}
