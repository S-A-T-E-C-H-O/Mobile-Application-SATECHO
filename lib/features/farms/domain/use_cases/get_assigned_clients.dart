import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';
import 'package:satecho_mobile/features/farms/domain/farm_repository.dart';

class GetAssignedClients {
  const GetAssignedClients(this._repository);

  final FarmRepository _repository;

  Future<List<AssignedClient>> call() => _repository.getAssignedClients();
}
