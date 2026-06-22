import 'package:satecho_mobile/features/field_visits/domain/scheduled_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_repository.dart';

class GetScheduledVisits {
  const GetScheduledVisits(this._repository);

  final FieldVisitRepository _repository;

  Future<List<ScheduledVisit>> call() => _repository.getScheduledVisits();
}
