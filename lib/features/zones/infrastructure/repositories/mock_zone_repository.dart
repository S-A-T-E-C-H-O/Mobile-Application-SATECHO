import '../../domain/entities/zone.dart';
import '../../domain/entities/zone_metric.dart';
import '../../domain/repositories/zone_repository.dart';

class MockZoneRepository implements ZoneRepository {
  final List<Zone> _zones = const [
    Zone(
      id: 'zone-a',
      farmId: 'farm-1',
      name: 'North Lot',
      crop: 'Corn',
      areaLabel: '12 Ha',
      risk: 'High',
      humidity: 32,
      metrics: [
        ZoneMetric(label: 'Humidity', value: '32', unit: '%', status: 'Low'),
        ZoneMetric(label: 'EC', value: '1.2', unit: '', status: 'Healthy'),
        ZoneMetric(
            label: 'Temperature', value: '22', unit: '°C', status: 'Normal'),
      ],
    ),
    Zone(
      id: 'zone-b',
      farmId: 'farm-1',
      name: 'South Lot',
      crop: 'Soybeans',
      areaLabel: '18 Ha',
      risk: 'High',
      humidity: 18,
      metrics: [
        ZoneMetric(label: 'Humidity', value: '18', unit: '%', status: 'Low'),
        ZoneMetric(label: 'EC', value: '1.9', unit: 'mS/cm', status: 'Rising'),
        ZoneMetric(
            label: 'Temperature', value: '25', unit: '°C', status: 'Warm'),
      ],
    ),
    Zone(
      id: 'zone-c',
      farmId: 'farm-1',
      name: 'East Lot',
      crop: 'Wheat',
      areaLabel: '15.5 Ha',
      risk: 'Medium',
      humidity: 27,
      metrics: [
        ZoneMetric(label: 'Humidity', value: '27', unit: '%', status: 'Low'),
        ZoneMetric(label: 'EC', value: '1.4', unit: '', status: 'Healthy'),
        ZoneMetric(
            label: 'Temperature', value: '23', unit: '°C', status: 'Normal'),
      ],
    ),
    Zone(
      id: 'sector-a',
      farmId: 'farm-2',
      name: 'Sector A',
      crop: 'Coffee',
      areaLabel: '140 ha',
      risk: 'Medium',
      humidity: 38,
      metrics: [
        ZoneMetric(label: 'Humidity', value: '38', unit: '%', status: 'Normal'),
        ZoneMetric(label: 'EC', value: '1.1', unit: '', status: 'Healthy'),
      ],
    ),
    Zone(
      id: 'sector-b',
      farmId: 'farm-2',
      name: 'Sector B',
      crop: 'Soy',
      areaLabel: '140 ha',
      risk: 'Medium',
      humidity: 52,
      metrics: [
        ZoneMetric(label: 'Humidity', value: '52', unit: '%', status: 'Normal'),
        ZoneMetric(label: 'EC', value: '1.9', unit: 'mS/cm', status: 'Rising'),
        ZoneMetric(
            label: 'Temperature', value: '25', unit: '°C', status: 'Warm'),
        ZoneMetric(label: 'Rain', value: '0', unit: 'mm', status: 'Dry'),
      ],
    ),
    Zone(
      id: 'sector-c',
      farmId: 'farm-2',
      name: 'Sector C',
      crop: 'Corn',
      areaLabel: '130 ha',
      risk: 'Low',
      humidity: 63,
      metrics: [
        ZoneMetric(
            label: 'Humidity', value: '63', unit: '%', status: 'Healthy'),
        ZoneMetric(label: 'EC', value: '0.8', unit: '', status: 'Healthy'),
      ],
    ),
  ];

  @override
  Future<Zone?> getZoneById(String zoneId) async {
    return _zones.where((zone) => zone.id == zoneId).firstOrNull;
  }

  @override
  Future<List<Zone>> getZonesByFarm(String farmId) async {
    return _zones.where((zone) => zone.farmId == farmId).toList();
  }

  @override
  Future<void> updateThresholds(
      String zoneId, Map<String, dynamic> data) async {}
}
