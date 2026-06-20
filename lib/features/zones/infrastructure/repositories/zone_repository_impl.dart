import '../../domain/entities/zone.dart';
import '../../domain/entities/zone_metric.dart';
import '../../domain/repositories/zone_repository.dart';
import '../data_sources/remote/zone_remote_data_source.dart';
import '../models/zone_model.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  const ZoneRepositoryImpl(this._remote);

  final ZoneRemoteDataSource _remote;

  @override
  Future<Zone?> getZoneById(String zoneId) async {
    final model = await _remote.getZoneById(zoneId);
    return model != null ? _toZone(model) : null;
  }

  @override
  Future<List<Zone>> getZonesByFarm(String farmId) async {
    final models = await _remote.getZonesByFarm(farmId);
    return models.map(_toZone).toList();
  }

  @override
  Future<void> updateThresholds(
      String zoneId, Map<String, dynamic> data) async {
    await _remote.updateThresholds(zoneId, data);
  }

  Zone _toZone(ZoneModel m) {
    return Zone(
      id: m.id.toString(),
      farmId: m.farmId.toString(),
      name: m.name,
      crop: _formatCrop(m.cropType),
      areaLabel: '${m.areaHectares.toStringAsFixed(1)} Ha',
      risk: 'Unknown',
      humidity: 0,
      metrics: const <ZoneMetric>[],
    );
  }

  String _formatCrop(String? cropType) {
    if (cropType == null) return 'Unknown';
    return cropType
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }
}
