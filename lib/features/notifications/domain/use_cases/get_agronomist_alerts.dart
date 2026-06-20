import 'package:satecho_mobile/features/notifications/domain/agronomist_alert.dart';
import 'package:satecho_mobile/features/notifications/domain/agronomist_alert_repository.dart';

class GetAgronomistAlerts {
  const GetAgronomistAlerts(this._repository);

  final AgronomistAlertRepository _repository;

  Future<List<AgronomistAlert>> call() => _repository.getAgronomistAlerts();
}
