import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_repository.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_status.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/plot_remote_data_source.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/sensor_reading_model.dart';
import 'package:satecho_mobile/features/soil_monitoring/data/zone_with_thresholds_model.dart';

class PlotRepositoryImpl implements PlotRepository {
  const PlotRepositoryImpl(this._remote);

  final PlotRemoteDataSource _remote;

  @override
  Future<List<Plot>> getPlots() async {
    final data = await _remote.fetchAllZonesWithTelemetry();
    return data.map(_toPlot).toList();
  }

  @override
  Future<Plot?> getPlotById(String plotId) async {
    final data = await _remote.fetchZoneWithTelemetry(plotId);
    if (data == null) return null;
    return _toPlot(data);
  }

  Plot _toPlot(ZoneWithTelemetry data) {
    return Plot(
      id: data.zone.id.toString(),
      name: data.zone.name,
      crop: data.zone.cropType ?? 'Unknown',
      lastActivityLabel: _lastActivityLabel(data.readings),
      status: _status(data.zone, data.readings),
      metrics: _metrics(data.readings),
    );
  }

  List<SensorMetric> _metrics(List<SensorReadingModel> readings) {
    const typeMap = <String, SensorMetricType>{
      'humidity_fc28': SensorMetricType.humidity,
      'MOISTURE': SensorMetricType.humidity,
      'temperature_ds18b20': SensorMetricType.temperature,
      'TEMPERATURE': SensorMetricType.temperature,
      'salinity_hr202l': SensorMetricType.electricalConductivity,
      'ELECTRICAL_CONDUCTIVITY': SensorMetricType.electricalConductivity,
    };

    return readings
        .where((r) =>
            typeMap.containsKey(r.metricType.toUpperCase()) ||
            typeMap.containsKey(r.metricType))
        .map((r) {
      final type = typeMap[r.metricType] ??
          typeMap[r.metricType.toUpperCase()] ??
          SensorMetricType.humidity;
      switch (type) {
        case SensorMetricType.humidity:
          return SensorMetric(
            type: SensorMetricType.humidity,
            label: 'Humidity',
            numericValue: r.value,
            displayValue: '${r.value.toStringAsFixed(0)}%',
          );
        case SensorMetricType.temperature:
          return SensorMetric(
            type: SensorMetricType.temperature,
            label: 'Temp',
            numericValue: r.value,
            displayValue: '${r.value.toStringAsFixed(0)}°',
          );
        case SensorMetricType.electricalConductivity:
          return SensorMetric(
            type: SensorMetricType.electricalConductivity,
            label: 'EC',
            numericValue: r.value,
            displayValue: r.value.toStringAsFixed(1),
          );
      }
    }).toList();
  }

  PlotStatus _status(ZoneModel zone, List<SensorReadingModel> readings) {
    if (zone.thresholds == null || readings.isEmpty) return PlotStatus.healthy;

    final moistureMetrics = {'humidity_fc28', 'MOISTURE'};
    return readings.any((r) {
      final upper = r.metricType.toUpperCase();
      final isMoisture = moistureMetrics.contains(r.metricType) ||
          moistureMetrics.contains(upper);
      if (!isMoisture) return false;
      if (r.value < zone.thresholds!.minMoisture) return true;
      if (r.value > zone.thresholds!.maxMoisture) return true;
      return false;
    })
        ? (readings.where((r) {
            final upper = r.metricType.toUpperCase();
            return moistureMetrics.contains(r.metricType) ||
                moistureMetrics.contains(upper);
          }).any((r) => r.value < zone.thresholds!.minMoisture)
            ? PlotStatus.critical
            : PlotStatus.warning)
        : PlotStatus.healthy;
  }

  String _lastActivityLabel(List<SensorReadingModel> readings) {
    if (readings.isEmpty) return 'No data';

    final timestamps = readings.map((r) => r.timestamp);
    final latest = timestamps.reduce((a, b) => a.isAfter(b) ? a : b);
    final diff = DateTime.now().difference(latest);

    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays} days ago';
  }
}
