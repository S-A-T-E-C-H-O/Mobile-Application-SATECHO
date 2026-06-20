import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/irrigation/data/irrigation_schedule_model.dart';
import 'package:satecho_mobile/features/irrigation/data/irrigation_session_model.dart';

class IrrigationRemoteDataSource {
  const IrrigationRemoteDataSource(this._client);

  final ApiClient _client;

  Future<IrrigationSessionModel?> getActiveSession(String zoneId) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiConstants.activeIrrigation(zoneId),
      );
      if (response.statusCode == 204 || response.data == null) return null;
      return IrrigationSessionModel.fromJson(response.data!);
    } catch (_) {
      return null;
    }
  }

  Future<IrrigationSessionModel> startIrrigation(
    String zoneId,
    int durationMinutes,
  ) async {
    // Fetch zone to get deviceId
    final zoneResponse =
        await _client.get<Map<String, dynamic>>(ApiConstants.zone(zoneId));
    final deviceId = zoneResponse.data?['deviceId'] as int?;

    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.startIrrigation(zoneId),
      data: {
        'deviceId': deviceId,
        'triggeredBy': 'MANUAL',
        'durationMinutes': durationMinutes,
      },
    );
    return IrrigationSessionModel.fromJson(response.data!);
  }

  Future<IrrigationSessionModel> stopIrrigation(String zoneId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.stopIrrigation(zoneId),
      data: <String, dynamic>{},
    );
    return IrrigationSessionModel.fromJson(response.data!);
  }

  Future<List<IrrigationScheduleModel>> getSchedules(String zoneId) async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.irrigationSchedules(zoneId),
    );
    return (response.data as List<dynamic>)
        .map((e) => IrrigationScheduleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<IrrigationSessionModel>> getHistory(String zoneId) async {
    try {
      final response = await _client.get<List<dynamic>>(
        ApiConstants.irrigationHistory(zoneId),
      );
      return (response.data as List<dynamic>)
          .map((e) =>
              IrrigationSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
