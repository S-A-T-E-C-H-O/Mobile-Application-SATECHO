import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';

class ActivityRemoteDataSource {
  const ActivityRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> logActivity({
    required String zoneId,
    required String type,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.activityLog,
      data: {'zoneId': int.parse(zoneId), 'type': type},
    );
    return response.data!;
  }
}
