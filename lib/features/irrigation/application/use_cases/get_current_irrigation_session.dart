import '../../domain/entities/irrigation_session.dart';
import '../../domain/repositories/irrigation_repository.dart';

class GetCurrentIrrigationSession {
  const GetCurrentIrrigationSession(this._repository);

  final IrrigationRepository _repository;

  Future<IrrigationSession> call(String plotId) {
    return _repository.getCurrentSession(plotId);
  }
}
