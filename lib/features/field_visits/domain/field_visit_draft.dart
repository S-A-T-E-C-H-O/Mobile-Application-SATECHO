class FieldVisitDraft {
  const FieldVisitDraft({
    required this.visitId,
    required this.completedItems,
    required this.notes,
    this.latitude,
    this.longitude,
    this.photoBase64,
  });

  final String visitId;
  final Set<int> completedItems;
  final String notes;
  final double? latitude;
  final double? longitude;
  final String? photoBase64;
}
