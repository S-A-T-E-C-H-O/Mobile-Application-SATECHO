import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';

class ParcelComparisonRemoteDataSource {
  const ParcelComparisonRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> compare(List<int> zoneIds) async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.parcelComparison,
      queryParameters: {'zoneIds': zoneIds.join(',')},
    );
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
