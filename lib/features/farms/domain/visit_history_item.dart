class VisitHistoryItem {
  const VisitHistoryItem({
    required this.title,
    required this.dateLabel,
    required this.description,
    this.recommendation,
  });

  final String title;
  final String dateLabel;
  final String description;
  final String? recommendation;
}
