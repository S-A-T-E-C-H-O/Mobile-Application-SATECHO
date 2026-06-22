class FieldVisitDraft {
  const FieldVisitDraft({
    required this.visitId,
    required this.completedItems,
    required this.notes,
  });

  final String visitId;
  final Set<int> completedItems;
  final String notes;
}
