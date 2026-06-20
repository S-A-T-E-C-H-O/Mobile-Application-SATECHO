import '../../domain/repositories/alert_repository.dart';

class ResolveAlert {
  const ResolveAlert(this._repository);

  final AlertRepository _repository;

  Future<void> call(String alertId) => _repository.markResolved(alertId);
}
