import 'package:satecho_mobile/features/field_visits/domain/field_visit_draft.dart';
import 'package:satecho_mobile/features/field_visits/domain/scheduled_visit.dart';

abstract class FieldVisitRepository {
  Future<List<ScheduledVisit>> getScheduledVisits();
  Future<void> saveFieldVisit(FieldVisitDraft draft);
  Future<ScheduledVisit> scheduleVisit({
    required int farmId,
    required DateTime scheduledAt,
    required String tag,
    required String noteTitle,
    required String noteBody,
    required bool urgent,
  });
}
