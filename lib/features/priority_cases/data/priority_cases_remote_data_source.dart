import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';

class PriorityCasesRemoteDataSource {
  const PriorityCasesRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getPriorityCases() async {
    final response =
        await _client.get<List<dynamic>>(ApiConstants.priorityCases);
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
