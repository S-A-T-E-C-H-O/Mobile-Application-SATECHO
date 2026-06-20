import '../../domain/entities/agronomist_alert.dart';
import '../../domain/repositories/agronomist_alert_repository.dart';

class GetAgronomistAlerts {
  const GetAgronomistAlerts(this._repository);

  final AgronomistAlertRepository _repository;

  Future<List<AgronomistAlert>> call() => _repository.getAgronomistAlerts();
}
