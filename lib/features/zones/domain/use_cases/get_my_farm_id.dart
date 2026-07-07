import 'package:satecho_mobile/features/zones/domain/zone_repository.dart';

class GetMyFarmId {
  const GetMyFarmId(this._repository);

  final ZoneRepository _repository;

  Future<String?> call() => _repository.getMyFarmId();
}
