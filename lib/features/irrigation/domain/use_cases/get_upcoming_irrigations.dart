import 'package:satecho_mobile/features/irrigation/domain/upcoming_irrigation.dart';
import 'package:satecho_mobile/features/irrigation/domain/irrigation_repository.dart';

class GetUpcomingIrrigations {
  const GetUpcomingIrrigations(this._repository);

  final IrrigationRepository _repository;

  Future<List<UpcomingIrrigation>> call() {
    return _repository.getUpcomingIrrigations();
  }
}
