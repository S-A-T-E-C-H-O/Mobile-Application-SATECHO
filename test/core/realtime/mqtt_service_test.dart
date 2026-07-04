import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/core/realtime/mqtt_service.dart';
import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';

void main() {
  group('MqttService payload handling', () {
    late RealtimeService realtime;
    late MqttService service;

    setUp(() {
      realtime = RealtimeService();
      service = MqttService(realtime: realtime);
    });

    tearDown(() {
      realtime.dispose();
    });

    test('emits irrigation status ON from a status payload', () async {
      final future = realtime.events.first;
      service.handlePayloadForTesting(
        'agrosafe/10/devices/42/status',
        '{"zone_id": "5", "irrigation": "ON"}',
      );
      final event = await future;
      expect(event.type, RealtimeEventType.irrigationStatus);
      expect(event.zoneId, '5');
      expect(event.irrigationRunning, isTrue);
    });

    test('emits irrigation status OFF from a boolean payload', () async {
      final future = realtime.events.first;
      service.handlePayloadForTesting(
        'agrosafe/10/devices/42/status',
        '{"zone_id": "5", "irrigation": false}',
      );
      final event = await future;
      expect(event.irrigationRunning, isFalse);
    });

    test('emits a sensor reading for moisture', () async {
      final future = realtime.events.first;
      service.handlePayloadForTesting(
        'agrosafe/10/devices/42/status',
        '{"zone_id": "5", "moisture": 42.5}',
      );
      final event = await future;
      expect(event.type, RealtimeEventType.sensorReading);
      expect(event.sensorMetric?.type, SensorMetricType.humidity);
      expect(event.sensorMetric?.numericValue, 42.5);
    });

    test('falls back to deviceId from topic when zone_id is absent', () async {
      final future = realtime.events.first;
      service.handlePayloadForTesting(
        'agrosafe/10/devices/42/status',
        '{"ec": 3.2}',
      );
      final event = await future;
      expect(event.zoneId, '42');
    });

    test('malformed JSON is ignored without throwing', () {
      expect(
        () => service.handlePayloadForTesting(
            'agrosafe/10/devices/42/status', 'not-json'),
        returnsNormally,
      );
    });

    test('topic without a device segment is ignored', () {
      expect(
        () => service.handlePayloadForTesting(
            'agrosafe/status', '{"moisture": 1}'),
        returnsNormally,
      );
    });
  });
}
