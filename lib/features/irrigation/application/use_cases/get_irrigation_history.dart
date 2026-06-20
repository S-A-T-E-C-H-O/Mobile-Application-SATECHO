import '../../domain/repositories/irrigation_repository.dart';

class GetIrrigationHistory {
  const GetIrrigationHistory(this._repository);

  final IrrigationRepository _repository;

  Future<List<Map<String, dynamic>>> call(String zoneId) =>
      _repository.getHistory(zoneId);
}
