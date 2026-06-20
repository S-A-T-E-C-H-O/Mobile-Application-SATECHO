class AgronomistAlert {
  const AgronomistAlert({
    required this.id,
    required this.farmName,
    required this.zoneName,
    required this.title,
    required this.timeLabel,
    required this.severity,
  });

  final String id;
  final String farmName;
  final String zoneName;
  final String title;
  final String timeLabel;
  final String severity;
}
