/// A system-generated activity record (EP-004-US020) — distinct from
/// [FarmActivity], which is the farmer's own manually-logged notes.
class ActivityLogEntry {
  const ActivityLogEntry({
    required this.id,
    required this.type,
    required this.description,
    required this.occurredAt,
  });

  final int id;
  final String type;
  final String description;
  final DateTime occurredAt;
}
