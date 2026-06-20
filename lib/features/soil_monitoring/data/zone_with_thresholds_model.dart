class ZoneModel {
  const ZoneModel({
    required this.id,
    required this.farmId,
    required this.name,
    this.cropType,
    this.deviceId,
    this.thresholds,
  });

  final int id;
  final int farmId;
  final String name;
  final String? cropType;
  final int? deviceId;
  final ThresholdModel? thresholds;

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] as int,
      farmId: json['farmId'] as int,
      name: json['name'] as String,
      cropType: json['cropType'] as String?,
      deviceId: json['deviceId'] as int?,
      thresholds: json['thresholds'] != null
          ? ThresholdModel.fromJson(json['thresholds'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ThresholdModel {
  const ThresholdModel({
    required this.minMoisture,
    required this.maxMoisture,
    required this.minEc,
    required this.maxEc,
    required this.minPh,
    required this.maxPh,
    required this.minTemperature,
    required this.maxTemperature,
  });

  final double minMoisture;
  final double maxMoisture;
  final double minEc;
  final double maxEc;
  final double minPh;
  final double maxPh;
  final double minTemperature;
  final double maxTemperature;

  factory ThresholdModel.fromJson(Map<String, dynamic> json) {
    return ThresholdModel(
      minMoisture: (json['minMoisture'] as num).toDouble(),
      maxMoisture: (json['maxMoisture'] as num).toDouble(),
      minEc: (json['minEc'] as num).toDouble(),
      maxEc: (json['maxEc'] as num).toDouble(),
      minPh: (json['minPh'] as num).toDouble(),
      maxPh: (json['maxPh'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
    );
  }
}
