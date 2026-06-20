import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/domain/zone_repository.dart';

class GetZonesByFarm {
  const GetZonesByFarm(this._repository);

  final ZoneRepository _repository;

  Future<List<Zone>> call(String farmId) => _repository.getZonesByFarm(farmId);
}
