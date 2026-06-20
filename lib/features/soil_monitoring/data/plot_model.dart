import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_status.dart';

class PlotModel {
  const PlotModel();

  static Plot fromMock({
    required String id,
    required String name,
    required String crop,
    required String lastActivityLabel,
    required PlotStatus status,
    List<SensorMetric> metrics = const [],
  }) {
    return Plot(
      id: id,
      name: name,
      crop: crop,
      lastActivityLabel: lastActivityLabel,
      status: status,
      metrics: metrics,
    );
  }
}
