import '../../domain/entities/irrigation_session.dart';
import '../../domain/repositories/irrigation_repository.dart';

class StartIrrigation {
  const StartIrrigation(this._repository);

  final IrrigationRepository _repository;

  Future<IrrigationSession> call(String plotId, int durationMinutes) {
    return _repository.startIrrigation(plotId, durationMinutes);
  }
}
