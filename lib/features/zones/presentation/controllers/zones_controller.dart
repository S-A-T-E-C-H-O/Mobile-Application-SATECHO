import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';
import 'package:satecho_mobile/features/zones/domain/use_cases/get_my_farm_id.dart';
import 'package:satecho_mobile/features/zones/domain/use_cases/get_zones_by_farm.dart';
import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/domain/zone_metric.dart';

class ZonesController extends ChangeNotifier {
  ZonesController(this._getMyFarmId, this._getZonesByFarm,
      {RealtimeService? realtime})
      : _realtime = realtime {
    _sensorSub =
        _realtime?.events.listen(_onRealtimeEvent);
  }

  final GetMyFarmId _getMyFarmId;
  final GetZonesByFarm _getZonesByFarm;
  final RealtimeService? _realtime;

  StreamSubscription<RealtimeEvent>? _sensorSub;

  bool isLoading = true;
  String? errorMessage;
  List<Zone> zones = [];
  String? farmId;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      farmId = await _getMyFarmId();
      if (farmId == null) {
        errorMessage = 'No se encontró una propiedad registrada.';
      } else {
        zones = await _getZonesByFarm(farmId!);
      }
    } catch (_) {
      errorMessage = 'No pudimos cargar las zonas de tu propiedad.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _onRealtimeEvent(RealtimeEvent event) {
    if (event.type != RealtimeEventType.sensorReading) return;
    final metric = event.sensorMetric;
    final zoneId = event.zoneId;
    if (metric == null || zoneId == null) return;

    final index = zones.indexWhere((z) => z.id == zoneId);
    if (index == -1) return;

    final zoneMetric = _toZoneMetric(metric);
    if (zoneMetric == null) return;

    final zone = zones[index];
    final newMetrics = zone.metrics
        .where((m) => m.label != zoneMetric.label)
        .followedBy([zoneMetric])
        .toList();

    final newHumidity = metric.type == SensorMetricType.humidity
        ? metric.numericValue.round()
        : zone.humidity;

    zones[index] = Zone(
      id: zone.id,
      farmId: zone.farmId,
      name: zone.name,
      crop: zone.crop,
      areaLabel: zone.areaLabel,
      risk: _determineRisk(newMetrics),
      humidity: newHumidity,
      metrics: newMetrics,
    );
    notifyListeners();
  }

  ZoneMetric? _toZoneMetric(SensorMetric metric) {
    final label = _metricLabelMap[metric.type];
    final unit = _metricUnitMap[metric.type];
    if (label == null || unit == null) return null;
    final formatted = metric.numericValue.toStringAsFixed(0);
    return ZoneMetric(
      label: label,
      value: formatted,
      unit: unit,
      status: _metricStatus(metric),
    );
  }

  String _metricStatus(SensorMetric metric) {
    final v = metric.numericValue;
    return switch (metric.type) {
      SensorMetricType.humidity when v < 25 => 'Critical',
      SensorMetricType.humidity when v < 40 => 'Warning',
      SensorMetricType.humidity => 'Optimal',
      SensorMetricType.temperature when v > 35 => 'Warning',
      SensorMetricType.temperature when v < 10 => 'Warning',
      SensorMetricType.temperature => 'Optimal',
      SensorMetricType.electricalConductivity when v > 5 => 'Warning',
      SensorMetricType.electricalConductivity => 'Optimal',
    };
  }

  String _determineRisk(List<ZoneMetric> metrics) {
    for (final m in metrics) {
      if (m.status == 'Critical') return 'Critical moisture';
      if (m.status == 'Warning') return 'Low moisture';
    }
    return 'Normal';
  }

  static const _metricLabelMap = {
    SensorMetricType.humidity: 'Humidity',
    SensorMetricType.temperature: 'Temperature',
    SensorMetricType.electricalConductivity: 'EC',
  };

  static const _metricUnitMap = {
    SensorMetricType.humidity: '%',
    SensorMetricType.temperature: '°C',
    SensorMetricType.electricalConductivity: 'dS/m',
  };

  @override
  void dispose() {
    _sensorSub?.cancel();
    super.dispose();
  }
}
