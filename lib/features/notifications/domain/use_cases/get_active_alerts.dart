import 'package:satecho_mobile/features/notifications/domain/farm_alert.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_repository.dart';

class GetActiveAlerts {
  const GetActiveAlerts(this._repository);

  final AlertRepository _repository;

  Future<List<FarmAlert>> call() => _repository.getActiveAlerts();
}
