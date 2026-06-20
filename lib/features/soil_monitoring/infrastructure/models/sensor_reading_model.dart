class SensorReadingModel {
  const SensorReadingModel({
    required this.metricType,
    required this.value,
    required this.timestamp,
  });

  final String metricType;
  final double value;
  final DateTime timestamp;

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      metricType: json['metricType'] as String,
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
