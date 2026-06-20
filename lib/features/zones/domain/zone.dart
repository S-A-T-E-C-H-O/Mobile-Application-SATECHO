import 'zone_metric.dart';

class Zone {
  const Zone({
    required this.id,
    required this.farmId,
    required this.name,
    required this.crop,
    required this.areaLabel,
    required this.risk,
    required this.humidity,
    required this.metrics,
  });

  final String id;
  final String farmId;
  final String name;
  final String crop;
  final String areaLabel;
  final String risk;
  final int humidity;
  final List<ZoneMetric> metrics;
}
