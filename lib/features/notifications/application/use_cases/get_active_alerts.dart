import '../../domain/entities/farm_alert.dart';
import '../../domain/repositories/alert_repository.dart';

class GetActiveAlerts {
  const GetActiveAlerts(this._repository);

  final AlertRepository _repository;

  Future<List<FarmAlert>> call() => _repository.getActiveAlerts();
}
