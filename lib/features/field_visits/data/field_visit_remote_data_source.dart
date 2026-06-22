import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';

class FieldVisitRemoteDataSource {
  const FieldVisitRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getScheduledVisits() async {
    final response =
        await _client.get<List<dynamic>>(ApiConstants.agronomistVisits);
    return (response.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<void> completeVisit(String visitId) async {
    await _client.post<void>(
      '${ApiConstants.agronomistVisits}/$visitId/complete',
      data: null,
    );
  }

  Future<Map<String, dynamic>> scheduleVisit({
    required int farmId,
    required String scheduledAt,
    required String tag,
    required String noteTitle,
    required String noteBody,
    required bool urgent,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.agronomistVisits,
      data: {
        'farmId': farmId,
        'scheduledAt': scheduledAt,
        'tag': tag,
        'noteTitle': noteTitle,
        'noteBody': noteBody,
        'urgent': urgent,
      },
    );
    return response.data!;
  }
}
