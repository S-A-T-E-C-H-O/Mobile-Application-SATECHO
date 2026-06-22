import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/farm_model.dart';

class FarmRemoteDataSource {
  const FarmRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<ClientDetailModel>> getClientsDetailed() async {
    final response = await _client
        .get<List<dynamic>>(ApiConstants.agronomistClientsDetailed);
    return (response.data as List<dynamic>)
        .map((e) => ClientDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ClientDetailModel?> getClientByFarmerId(int farmerId) async {
    try {
      final all = await getClientsDetailed();
      return all.where((c) => c.farmerId == farmerId).firstOrNull;
    } catch (_) {
      return null;
    }
  }
}
