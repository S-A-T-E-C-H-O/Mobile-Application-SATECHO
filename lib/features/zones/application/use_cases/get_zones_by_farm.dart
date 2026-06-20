import '../../domain/entities/zone.dart';
import '../../domain/repositories/zone_repository.dart';

class GetZonesByFarm {
  const GetZonesByFarm(this._repository);

  final ZoneRepository _repository;

  Future<List<Zone>> call(String farmId) => _repository.getZonesByFarm(farmId);
}
