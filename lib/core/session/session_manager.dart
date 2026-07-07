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

  bool _isLoggingOut = false;

  /// The single source of truth for ending a session — MQTT disconnect,
  /// storage wipe and the UI callback that routes back to login all happen
  /// here. Every logout path (manual button, expired-session, HTTP 401)
  /// must call this instead of talking to storage/MQTT directly, or the UI
  /// won't be notified and the app is left in an authenticated-looking
  /// limbo with a dead token.
  ///
  /// Guarded against concurrent invocations: a manual logout tap racing
  /// with a 401 fired by an in-flight request (or several 401s arriving
  /// together) must still run this exactly once.
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
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
    } finally {
      _isLoggingOut = false;
    }
  }
}
