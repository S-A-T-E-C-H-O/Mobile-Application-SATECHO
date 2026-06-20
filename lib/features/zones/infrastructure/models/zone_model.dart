class ZoneModel {
  const ZoneModel({
    required this.id,
    required this.farmId,
    required this.name,
    required this.areaHectares,
    required this.cropType,
    this.deviceId,
  });

  final int id;
  final int farmId;
  final String name;
  final double areaHectares;
  final String? cropType;
  final int? deviceId;

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] as int,
      farmId: json['farmId'] as int,
      name: json['name'] as String,
      areaHectares: (json['areaHectares'] as num).toDouble(),
      cropType: json['cropType'] as String?,
      deviceId: json['deviceId'] as int?,
    );
  }
}
