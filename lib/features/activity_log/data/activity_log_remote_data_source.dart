import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';

class ActivityLogRemoteDataSource {
  const ActivityLogRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getActivityLog({
    required int farmId,
    String? type,
    required int page,
    int size = 100,
  }) async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.activityLog,
      queryParameters: {
        'farmId': farmId,
        if (type != null) 'type': type,
        'page': page,
        'size': size,
      },
    );
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
