import 'package:satecho_mobile/features/soil_monitoring/domain/plot_status.dart';
import 'sensor_metric.dart';

class Plot {
  const Plot({
    required this.id,
    required this.name,
    required this.crop,
    required this.lastActivityLabel,
    required this.status,
    required this.metrics,
  });

  final String id;
  final String name;
  final String crop;
  final String lastActivityLabel;
  final PlotStatus status;
  final List<SensorMetric> metrics;

  int? get humidity {
    return metrics
        .where((m) => m.type == SensorMetricType.humidity)
        .map((m) => m.numericValue.round())
        .firstOrNull;
  }
}
