class ScheduledVisit {
  const ScheduledVisit({
    required this.id,
    required this.farmId,
    required this.farmName,
    required this.ownerName,
    required this.dateLabel,
    required this.tag,
    required this.noteTitle,
    required this.noteBody,
    required this.urgent,
  });

  final String id;
  final String farmId;
  final String farmName;
  final String ownerName;
  final String dateLabel;
  final String tag;
  final String noteTitle;
  final String noteBody;
  final bool urgent;
}
