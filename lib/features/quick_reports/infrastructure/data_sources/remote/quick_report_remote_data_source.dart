import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/farms/infrastructure/models/farm_model.dart';

class QuickReportRemoteDataSource {
  const QuickReportRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<ClientDetailModel>> getClientsDetailed() async {
    final response = await _client
        .get<List<dynamic>>(ApiConstants.agronomistClientsDetailed);
    return (response.data as List<dynamic>)
        .map((e) => ClientDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
