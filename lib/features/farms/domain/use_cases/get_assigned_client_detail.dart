import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';
import 'package:satecho_mobile/features/farms/domain/farm_repository.dart';

class GetAssignedClientDetail {
  const GetAssignedClientDetail(this._repository);

  final FarmRepository _repository;

  Future<AssignedClient?> call(String farmId) {
    return _repository.getAssignedClientByFarmId(farmId);
  }
}
