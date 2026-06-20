import '../../domain/entities/irrigation_session.dart';
import '../../domain/repositories/irrigation_repository.dart';

class StopIrrigation {
  const StopIrrigation(this._repository);

  final IrrigationRepository _repository;

  Future<IrrigationSession> call(String plotId) {
    return _repository.stopIrrigation(plotId);
  }
}
