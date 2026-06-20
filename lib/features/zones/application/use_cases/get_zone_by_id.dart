import '../../domain/entities/zone.dart';
import '../../domain/repositories/zone_repository.dart';

class GetZoneById {
  const GetZoneById(this._repository);

  final ZoneRepository _repository;

  Future<Zone?> call(String zoneId) => _repository.getZoneById(zoneId);
}
