class ParcelComparison {
  const ParcelComparison({
    required this.zoneId,
    required this.zoneName,
    this.soilMoisture,
    this.soilTemperature,
    this.electricalConductivity,
    this.areaHectares,
    this.cropType,
  });

  final int zoneId;
  final String? zoneName;
  final double? soilMoisture;
  final double? soilTemperature;
  final double? electricalConductivity;
  final double? areaHectares;
  final String? cropType;
}
