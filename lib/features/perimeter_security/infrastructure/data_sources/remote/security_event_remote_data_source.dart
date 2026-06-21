import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/models/security_event_model.dart';

class SecurityEventRemoteDataSource {
  const SecurityEventRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<SecurityEventModel>> getSecurityEvents(String farmId) async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.farmSecurityEvents(farmId),
    );
    return (response.data as List<dynamic>)
        .map((e) => SecurityEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
