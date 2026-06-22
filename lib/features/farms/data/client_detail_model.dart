class ClientDetailModel {
  const ClientDetailModel({
    required this.id,
    required this.agronomistId,
    required this.farmerId,
    this.farmId,
    this.farmerName,
    this.farmName,
    this.location,
    this.cropType,
    required this.hectares,
    required this.zoneCount,
    this.soilHumidity,
    this.temperature,
    this.ec,
    required this.active,
  });

  final int id;
  final int agronomistId;
  final int farmerId;
  final int? farmId;
  final String? farmerName;
  final String? farmName;
  final String? location;
  final String? cropType;
  final double hectares;
  final int zoneCount;
  final double? soilHumidity;
  final double? temperature;
  final double? ec;
  final bool active;

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailModel(
      id: json['id'] as int,
      agronomistId: json['agronomistId'] as int,
      farmerId: json['farmerId'] as int,
      farmId: json['farmId'] as int?,
      farmerName: json['farmerName'] as String?,
      farmName: json['farmName'] as String?,
      location: json['location'] as String?,
      cropType: json['cropType'] as String?,
      hectares: (json['hectares'] as num?)?.toDouble() ?? 0.0,
      zoneCount: json['zoneCount'] as int? ?? 0,
      soilHumidity: (json['soilHumidity'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      ec: (json['ec'] as num?)?.toDouble(),
      active: json['active'] as bool? ?? true,
    );
  }
}
