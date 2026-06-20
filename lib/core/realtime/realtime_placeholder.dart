import 'dart:async';

import 'package:satecho_mobile/features/perimeter_security/domain/security_event.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';

enum RealtimeEventType {
  sensorReading,
  irrigationStatus,
  securityPirStatus,
}

class RealtimeEvent {
  const RealtimeEvent({
    required this.type,
    this.sensorMetric,
    this.irrigationRunning,
    this.securityEvent,
    this.zoneId,
  });

  final RealtimeEventType type;
  final SensorMetric? sensorMetric;
  final bool? irrigationRunning;
  final SecurityEvent? securityEvent;
  final String? zoneId;
}

class RealtimeService {
  RealtimeService();

  final StreamController<RealtimeEvent> _controller =
  StreamController<RealtimeEvent>.broadcast();

  Stream<RealtimeEvent> get events => _controller.stream;

  Stream<RealtimeEvent> securityEvents() =>
      events.where((e) => e.type == RealtimeEventType.securityPirStatus);

  Stream<RealtimeEvent> irrigationStatus(String zoneId) =>
      events.where((e) =>
      e.type == RealtimeEventType.irrigationStatus &&
          e.zoneId == zoneId);

  Stream<RealtimeEvent> sensorReadings(String zoneId) =>
      events.where((e) =>
      e.type == RealtimeEventType.sensorReading && e.zoneId == zoneId);

  void emit(RealtimeEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void emitSensorReading(String zoneId, SensorMetric metric) {
    emit(RealtimeEvent(
      type: RealtimeEventType.sensorReading,
      zoneId: zoneId,
      sensorMetric: metric,
    ));
  }

  void emitIrrigationStatus(String zoneId, bool running) {
    emit(RealtimeEvent(
      type: RealtimeEventType.irrigationStatus,
      zoneId: zoneId,
      irrigationRunning: running,
    ));
  }

  void emitSecurityEvent(SecurityEvent event) {
    emit(RealtimeEvent(
      type: RealtimeEventType.securityPirStatus,
      securityEvent: event,
      zoneId: event.zoneId,
    ));
  }

  void dispose() {
    _controller.close();
  }
}
