import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';

/// Connects to the shared AgroSafe MQTT broker and subscribes to
/// `agrosafe/{farmId}/devices/{deviceId}/status` so the app receives sensor
/// and irrigation state updates in real time instead of polling.
///
/// Reconnects with exponential backoff (2s, 4s, 8s, 16s, 30s — capped),
/// giving up after 5 consecutive attempts (EP-004-TS002).
class MqttService {
  MqttService({
    required RealtimeService realtime,
    String brokerHost = 'agrosafe-mqtt.eastus2.azurecontainer.io',
    int brokerPort = 1883,
  })  : _realtime = realtime,
        _brokerHost = brokerHost,
        _brokerPort = brokerPort;

  static const int maxReconnectAttempts = 5;

  final RealtimeService _realtime;
  final String _brokerHost;
  final int _brokerPort;

  MqttServerClient? _client;
  int _reconnectAttempts = 0;
  bool _manuallyDisconnected = false;
  String _farmId = '+';
  String _deviceId = '+';

  /// Subscribes to updates for a specific farm (and optionally a specific
  /// device). Defaults to a wildcard subscription covering all farms/devices
  /// when the caller doesn't yet know the current farmId.
  Future<void> connect({String farmId = '+', String deviceId = '+'}) async {
    _manuallyDisconnected = false;
    _farmId = farmId;
    _deviceId = deviceId;

    final clientId = 'satecho-mobile-${DateTime.now().millisecondsSinceEpoch}';
    final client = MqttServerClient(_brokerHost, clientId)
      ..port = _brokerPort
      ..logging(on: false)
      ..keepAlivePeriod = 30
      ..autoReconnect = false
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected;
    _client = client;

    try {
      await client.connect();
    } catch (_) {
      client.disconnect();
      _scheduleReconnect();
      return;
    }

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      _scheduleReconnect();
      return;
    }

    _reconnectAttempts = 0;
    final topic = 'agrosafe/$farmId/devices/$deviceId/status';
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates?.listen(_onMessages);
  }

  void _onConnected() {
    _reconnectAttempts = 0;
  }

  void _onDisconnected() {
    if (_manuallyDisconnected) return;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) return;
    _reconnectAttempts++;
    final delaySeconds = min(30, pow(2, _reconnectAttempts).toInt());
    Future.delayed(Duration(seconds: delaySeconds), () {
      if (!_manuallyDisconnected) {
        connect(farmId: _farmId, deviceId: _deviceId);
      }
    });
  }

  void _onMessages(List<MqttReceivedMessage<MqttMessage>> events) {
    for (final event in events) {
      final message = event.payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        message.payload.message,
      );
      _handlePayload(event.topic, payload);
    }
  }

  @visibleForTesting
  void handlePayloadForTesting(String topic, String payload) =>
      _handlePayload(topic, payload);

  void _handlePayload(String topic, String payload) {
    final Map<String, dynamic> data;
    try {
      data = json.decode(payload) as Map<String, dynamic>;
    } catch (_) {
      return; // ignore malformed payload
    }

    final parts = topic.split('/');
    if (parts.length < 4) return;
    final deviceId = parts[3];
    final zoneId = (data['zone_id'] ?? data['zoneId'] ?? deviceId).toString();

    final irrigation = data['irrigation'];
    if (irrigation != null) {
      _realtime.emitIrrigationStatus(
          zoneId, irrigation == 'ON' || irrigation == true);
    }

    _maybeEmitMetric(zoneId, SensorMetricType.humidity, data['moisture']);
    _maybeEmitMetric(
        zoneId, SensorMetricType.electricalConductivity, data['ec']);
    _maybeEmitMetric(zoneId, SensorMetricType.temperature, data['temperature']);
  }

  void _maybeEmitMetric(
      String zoneId, SensorMetricType type, dynamic rawValue) {
    if (rawValue == null) return;
    final value = (rawValue is num)
        ? rawValue.toDouble()
        : double.tryParse(rawValue.toString());
    if (value == null) return;
    _realtime.emitSensorReading(
      zoneId,
      SensorMetric(
        type: type,
        label: type.name,
        numericValue: value,
        displayValue: value.toStringAsFixed(1),
      ),
    );
  }

  void disconnect() {
    _manuallyDisconnected = true;
    _client?.disconnect();
  }
}
