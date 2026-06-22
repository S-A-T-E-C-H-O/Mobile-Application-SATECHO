import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';
import 'package:satecho_mobile/features/farms/domain/farm.dart';
import 'package:satecho_mobile/features/farms/domain/visit_history_item.dart';
import 'package:satecho_mobile/features/farms/domain/farm_repository.dart';
import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/infrastructure/data_sources/remote/zone_remote_data_source.dart';
import 'package:satecho_mobile/features/zones/infrastructure/repositories/zone_repository_impl.dart';
import 'package:satecho_mobile/features/farms/infrastructure/data_sources/remote/farm_remote_data_source.dart';
import 'package:satecho_mobile/features/farms/infrastructure/models/farm_model.dart';

class FarmRepositoryImpl implements FarmRepository {
  const FarmRepositoryImpl(this._remote, this._zoneRemote);

  final FarmRemoteDataSource _remote;
  final ZoneRemoteDataSource _zoneRemote;

  @override
  Future<List<AssignedClient>> getAssignedClients() async {
    final clients = await _remote.getClientsDetailed();
    final futures = clients.map((c) => _toAssignedClient(c));
    return Future.wait(futures);
  }

  @override
  Future<AssignedClient?> getAssignedClientByFarmId(String farmId) async {
    final model = await _remote.getClientByFarmerId(int.parse(farmId));
    if (model == null) return null;
    return _toAssignedClient(model);
  }

  Future<AssignedClient> _toAssignedClient(ClientDetailModel m) async {
    final zoneRepo = ZoneRepositoryImpl(_zoneRemote);
    final List<Zone> zones = m.farmId != null
        ? await zoneRepo.getZonesByFarm(m.farmId!.toString())
        : const [];

    final farm = Farm(
      id: m.farmerId.toString(),
      name: m.farmName ?? 'Farm ${m.farmerId}',
      ownerName: m.farmerName ?? 'Unknown',
      crop: _formatCrop(m.cropType),
      zoneLabel: '${m.zoneCount} zone${m.zoneCount == 1 ? '' : 's'}',
      hectaresLabel: '${m.hectares.toStringAsFixed(1)} ha',
      status: _status(m),
      alertCount: 0,
      soilHumidity: m.soilHumidity?.round(),
      temperature: m.temperature?.round(),
      ec: m.ec,
      ndvi: 0.0,
    );

    return AssignedClient(
      farm: farm,
      zones: zones,
      visitHistory: const <VisitHistoryItem>[],
    );
  }

  String _status(ClientDetailModel m) {
    if (m.soilHumidity == null) return 'No data';
    return 'Optimal';
  }

  String _formatCrop(String? cropType) {
    if (cropType == null) return 'Unknown';
    return cropType
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }
}
