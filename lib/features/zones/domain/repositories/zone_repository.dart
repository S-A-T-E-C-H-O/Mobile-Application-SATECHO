import '../entities/zone.dart';

abstract class ZoneRepository {
  Future<List<Zone>> getZonesByFarm(String farmId);
  Future<Zone?> getZoneById(String zoneId);
  Future<void> updateThresholds(String zoneId, Map<String, dynamic> data);
}
