import '../../domain/entities/upcoming_irrigation.dart';
import '../../domain/repositories/irrigation_repository.dart';

class GetUpcomingIrrigations {
  const GetUpcomingIrrigations(this._repository);

  final IrrigationRepository _repository;

  Future<List<UpcomingIrrigation>> call() {
    return _repository.getUpcomingIrrigations();
  }
}
