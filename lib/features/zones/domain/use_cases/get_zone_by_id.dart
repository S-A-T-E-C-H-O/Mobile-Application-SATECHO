import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/domain/zone_repository.dart';

class GetZoneById {
  const GetZoneById(this._repository);

  final ZoneRepository _repository;

  Future<Zone?> call(String zoneId) => _repository.getZoneById(zoneId);
}
