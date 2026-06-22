class AgronomistRecommendation {
  const AgronomistRecommendation({
    required this.id,
    required this.farmName,
    required this.zoneName,
    required this.problem,
    required this.priority,
    required this.status,
  });

  final String id;
  final String farmName;
  final String zoneName;
  final String problem;
  final String priority;
  final String status;
}
