import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/realtime/mqtt_service.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';

class SessionManager {
  SessionManager({
    required TokenStorage tokenStorage,
    MqttService? mqttService,
  })  : _tokenStorage = tokenStorage,
        _mqttService = mqttService;

  final TokenStorage _tokenStorage;
  final MqttService? _mqttService;

  VoidCallback? onSessionExpired;

  Future<void> logout() async {
    try {
      _mqttService?.disconnect();
    } catch (e) {
      debugPrint('[SessionManager] MQTT disconnect error: $e');
    }

    try {
      await _tokenStorage.clear();
    } catch (e) {
      debugPrint('[SessionManager] Token clear error: $e');
    }

    onSessionExpired?.call();
  }
}
