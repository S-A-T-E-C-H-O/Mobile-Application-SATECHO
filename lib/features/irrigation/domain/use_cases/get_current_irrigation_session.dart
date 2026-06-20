import 'package:satecho_mobile/features/irrigation/domain/irrigation_session.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_repository.dart';

class GetCurrentIrrigationSession {
  const GetCurrentIrrigationSession(this._repository);

  final IrrigationRepository _repository;

  Future<IrrigationSession> call(String plotId) {
    return _repository.getCurrentSession(plotId);
  }
}
