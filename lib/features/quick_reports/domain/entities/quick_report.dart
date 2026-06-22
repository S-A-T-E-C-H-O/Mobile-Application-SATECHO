class QuickReport {
  const QuickReport({
    required this.id,
    required this.farmName,
    required this.ownerName,
    required this.crop,
    required this.areaLabel,
    required this.alerts,
    required this.recommendations,
    required this.records,
    required this.riskColor,
  });

  final String id;
  final String farmName;
  final String ownerName;
  final String crop;
  final String areaLabel;
  final int alerts;
  final int recommendations;
  final int records;
  final String riskColor;
}
