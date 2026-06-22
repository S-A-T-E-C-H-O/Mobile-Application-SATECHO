import 'package:satecho_mobile/features/field_visits/domain/field_visit_draft.dart';
import 'package:satecho_mobile/features/field_visits/domain/scheduled_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_repository.dart';

class MockFieldVisitRepository implements FieldVisitRepository {
  final List<FieldVisitDraft> saved = [];

  @override
  Future<List<ScheduledVisit>> getScheduledVisits() async {
    return const [
      ScheduledVisit(
        id: 'visit-1',
        farmId: 'farm-2',
        farmName: 'Fazenda Boa Vista',
        ownerName: 'Carlos Silva',
        dateLabel: 'Today, 09:00 AM',
        tag: 'Urgent Sensor Check',
        noteTitle: 'Sector B-4',
        noteBody: 'High priority review',
        urgent: true,
      ),
      ScheduledVisit(
        id: 'visit-2',
        farmId: 'farm-1',
        farmName: 'Sitio Esperanza',
        ownerName: 'Ana Oliveira',
        dateLabel: 'Tomorrow, 14:00 PM',
        tag: 'Soil Sampling',
        noteTitle: 'Prep Required',
        noteBody: 'Bring sterile sampling kits and portable pH meter.',
        urgent: false,
      ),
      ScheduledVisit(
        id: 'visit-3',
        farmId: 'farm-3',
        farmName: 'Fazenda Sol Nascente',
        ownerName: 'Roberto Mendes',
        dateLabel: 'Wed, 08:30 AM',
        tag: 'Drone Survey',
        noteTitle: 'Weather Check',
        noteBody: 'Conditions optimal. Light wind, no rain expected.',
        urgent: false,
      ),
    ];
  }

  @override
  Future<void> saveFieldVisit(FieldVisitDraft draft) async {
    saved.add(draft);
  }

  @override
  Future<ScheduledVisit> scheduleVisit({
    required int farmId,
    required DateTime scheduledAt,
    required String tag,
    required String noteTitle,
    required String noteBody,
    required bool urgent,
  }) async {
    return ScheduledVisit(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      farmId: farmId.toString(),
      farmName: 'Farm $farmId',
      ownerName: 'Owner',
      dateLabel: scheduledAt.toLocal().toString().substring(0, 16),
      tag: tag,
      noteTitle: noteTitle,
      noteBody: noteBody,
      urgent: urgent,
    );
  }
}
