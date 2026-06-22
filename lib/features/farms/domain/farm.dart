class Farm {
  const Farm({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.crop,
    required this.zoneLabel,
    required this.hectaresLabel,
    required this.status,
    required this.alertCount,
    required this.soilHumidity,
    required this.temperature,
    required this.ec,
    required this.ndvi,
  });

  final String id;
  final String name;
  final String ownerName;
  final String crop;
  final String zoneLabel;
  final String hectaresLabel;
  final String status;
  final int alertCount;
  final int? soilHumidity;
  final int? temperature;
  final double? ec;
  final double ndvi;
}
