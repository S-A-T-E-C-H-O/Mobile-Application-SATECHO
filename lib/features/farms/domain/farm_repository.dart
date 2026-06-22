import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';

abstract class FarmRepository {
  Future<List<AssignedClient>> getAssignedClients();
  Future<AssignedClient?> getAssignedClientByFarmId(String farmId);
}
