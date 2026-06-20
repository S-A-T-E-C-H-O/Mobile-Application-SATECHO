import 'package:satecho_mobile/features/irrigation/domain/irrigation_session.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_repository.dart';

class StartIrrigation {
  const StartIrrigation(this._repository);

  final IrrigationRepository _repository;

  Future<IrrigationSession> call(String plotId, int durationMinutes) {
    return _repository.startIrrigation(plotId, durationMinutes);
  }
}
