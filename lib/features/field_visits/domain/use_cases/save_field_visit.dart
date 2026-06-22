import 'package:satecho_mobile/features/field_visits/domain/field_visit_draft.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_repository.dart';

class SaveFieldVisit {
  const SaveFieldVisit(this._repository);

  final FieldVisitRepository _repository;

  Future<void> call(FieldVisitDraft draft) => _repository.saveFieldVisit(draft);
}
