import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/domain/zone_metric.dart';
import 'package:satecho_mobile/features/zones/domain/zone_repository.dart';
import 'package:satecho_mobile/features/zones/data/zone_remote_data_source.dart';
import 'package:satecho_mobile/features/zones/data/zone_model.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  const ZoneRepositoryImpl(this._remote);

  final ZoneRemoteDataSource _remote;

  @override
  Future<Zone?> getZoneById(String zoneId) async {
    final model = await _remote.getZoneById(zoneId);
    if (model == null) return null;
    final telemetry = await _remote.getLatestTelemetry(zoneId);
    return _toZone(model, telemetry);
  }

  @override
  Future<List<Zone>> getZonesByFarm(String farmId) async {
    final models = await _remote.getZonesByFarm(farmId);
    return models.map((m) => _toZone(m, const {})).toList();
  }

  @override
  Future<void> updateThresholds(
      String zoneId, Map<String, dynamic> data) async {
    await _remote.updateThresholds(zoneId, data);
  }

  Zone _toZone(ZoneModel m, Map<String, double?> telemetry) {
    final metrics = _buildMetrics(telemetry);
    return Zone(
      id: m.id.toString(),
      farmId: m.farmId.toString(),
      name: m.name,
      crop: _formatCrop(m.cropType),
      areaLabel: '${m.areaHectares.toStringAsFixed(1)} Ha',
      risk: _determineRisk(telemetry),
      humidity: (telemetry['SOIL_MOISTURE'] ?? 0).round(),
      metrics: metrics,
    );
  }

  List<ZoneMetric> _buildMetrics(Map<String, double?> telemetry) {
    final metricDefs = [
      ('SOIL_MOISTURE', 'Humidity', '%'),
      ('SOIL_TEMPERATURE', 'Temperature', '°C'),
      ('ELECTRICAL_CONDUCTIVITY', 'EC', 'dS/m'),
      ('SOIL_PH', 'pH', ''),
      ('AMBIENT_TEMPERATURE', 'Ambient', '°C'),
      ('HUMIDITY', 'Air Humidity', '%'),
    ];

    return metricDefs
        .map((def) {
          final value = telemetry[def.$1];
          if (value == null) return null;
          final formatted = def.$1 == 'SOIL_PH'
              ? value.toStringAsFixed(1)
              : value.toStringAsFixed(0);
          final status = _metricStatus(def.$1, value);
          return ZoneMetric(
            label: def.$2,
            value: formatted,
            unit: def.$3,
            status: status,
          );
        })
        .whereType<ZoneMetric>()
        .toList();
  }

  String _determineRisk(Map<String, double?> telemetry) {
    final moisture = telemetry['SOIL_MOISTURE'];
    final temp = telemetry['SOIL_TEMPERATURE'];
    if (moisture != null && moisture < 25) return 'Critical moisture';
    if (temp != null && temp > 35) return 'High temperature';
    if (moisture != null && moisture < 40) return 'Low moisture';
    return 'Normal';
  }

  String _metricStatus(String metricType, double value) {
    return switch (metricType) {
      'SOIL_MOISTURE' when value < 25 => 'Critical',
      'SOIL_MOISTURE' when value < 40 => 'Warning',
      'SOIL_MOISTURE' => 'Optimal',
      'SOIL_TEMPERATURE' when value > 35 => 'Warning',
      'SOIL_TEMPERATURE' when value < 10 => 'Warning',
      'SOIL_TEMPERATURE' => 'Optimal',
      'ELECTRICAL_CONDUCTIVITY' when value > 5 => 'Warning',
      'ELECTRICAL_CONDUCTIVITY' => 'Optimal',
      _ => 'Normal',
    };
  }

  String _formatCrop(String? cropType) {
    if (cropType == null) return 'Unknown';
    return cropType
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }
}
