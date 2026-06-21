import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/repositories/security_event_repository.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/data_sources/remote/security_event_remote_data_source.dart';

class SecurityEventRepositoryImpl implements SecurityEventRepository {
  const SecurityEventRepositoryImpl(this._remote, this._client);

  final SecurityEventRemoteDataSource _remote;
  final ApiClient _client;

  @override
  Future<List<SecurityEvent>> getSecurityEvents() async {
    try {
      final farmsResponse =
          await _client.get<List<dynamic>>(ApiConstants.farms);
      final farms = farmsResponse.data as List<dynamic>;
      if (farms.isEmpty) return [];

      final farmId = (farms.first as Map<String, dynamic>)['id'].toString();
      final models = await _remote.getSecurityEvents(farmId);

      return models
          .map((m) => SecurityEvent(
                id: m.id.toString(),
                title: m.classification == 'security_pir_status'
                    ? 'Movimiento detectado en ${m.locationDescription ?? 'Zona desconocida'}'
                    : m.locationDescription != null
                        ? '${m.classification} at ${m.locationDescription}'
                        : m.classification,
                zoneId: m.id.toString(),
                zoneName: m.locationDescription ?? 'Desconocida',
                createdAt: m.detectedAt,
                classification: m.classification,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
