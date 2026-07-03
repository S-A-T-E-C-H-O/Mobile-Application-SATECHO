import 'package:satecho_mobile/features/field_visits/domain/field_visit_draft.dart';
import 'package:satecho_mobile/features/field_visits/domain/scheduled_visit.dart';
import 'package:satecho_mobile/features/field_visits/domain/field_visit_repository.dart';
import 'package:satecho_mobile/features/field_visits/data/field_visit_remote_data_source.dart';

class FieldVisitRepositoryImpl implements FieldVisitRepository {
  const FieldVisitRepositoryImpl(this._remote);

  final FieldVisitRemoteDataSource _remote;

  @override
  Future<List<ScheduledVisit>> getScheduledVisits() async {
    final items = await _remote.getScheduledVisits();
    return items.map(_toVisit).toList();
  }

  @override
  Future<void> saveFieldVisit(FieldVisitDraft draft) async {
    await _remote.completeVisit(
      draft.visitId,
      latitude: draft.latitude,
      longitude: draft.longitude,
      photoBase64: draft.photoBase64,
    );
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
    final json = await _remote.scheduleVisit(
      farmId: farmId,
      scheduledAt: scheduledAt.toUtc().toIso8601String(),
      tag: tag,
      noteTitle: noteTitle,
      noteBody: noteBody,
      urgent: urgent,
    );
    return _toVisit(json);
  }

  ScheduledVisit _toVisit(Map<String, dynamic> json) {
    final scheduledAt = json['scheduledAt'] != null
        ? DateTime.tryParse(json['scheduledAt'] as String)
        : null;
    return ScheduledVisit(
      id: json['id'].toString(),
      farmId: json['farmId'].toString(),
      farmName: json['farmName'] as String? ?? 'Unknown Farm',
      ownerName: json['ownerName'] as String? ?? 'Unknown',
      dateLabel: scheduledAt != null ? _formatDate(scheduledAt) : 'TBD',
      tag: json['tag'] as String? ?? '',
      noteTitle: json['noteTitle'] as String? ?? '',
      noteBody: json['noteBody'] as String? ?? '',
      urgent: json['urgent'] as bool? ?? false,
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);
    final timeLabel =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    if (date == today) return 'Today, $timeLabel';
    if (date == tomorrow) return 'Tomorrow, $timeLabel';

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[dt.weekday - 1]}, $timeLabel';
  }
}
