class RecommendationDraft {
  const RecommendationDraft({
    required this.farmerId,
    required this.zoneId,
    required this.problem,
    required this.product,
    required this.dose,
    required this.suggestedDate,
    required this.priority,
  });

  final int farmerId;
  final String zoneId;
  final String problem;
  final String product;
  final String dose;
  final String suggestedDate;
  final String priority;
}
