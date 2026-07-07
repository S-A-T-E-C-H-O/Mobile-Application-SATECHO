import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/core/realtime/mqtt_service.dart';
import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/core/session/session_manager.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}

class _SpyMqttService extends MqttService {
  _SpyMqttService() : super(realtime: RealtimeService());

  int disconnectCalls = 0;

  @override
  void disconnect() {
    disconnectCalls++;
    super.disconnect();
  }
}

void main() {
  group('SessionManager.logout', () {
    test('clears token storage and notifies onSessionExpired', () async {
      final tokenStorage = TokenStorage(_FakeSecureStorage());
      await tokenStorage.saveToken('abc123');
      final sessionManager = SessionManager(tokenStorage: tokenStorage);

      var expiredCalls = 0;
      sessionManager.onSessionExpired = () => expiredCalls++;

      await sessionManager.logout();

      expect(await tokenStorage.readToken(), isNull);
      expect(expiredCalls, 1);
    });

    test('disconnects MQTT when a service is attached', () async {
      final tokenStorage = TokenStorage(_FakeSecureStorage());
      final mqtt = _SpyMqttService();
      final sessionManager =
          SessionManager(tokenStorage: tokenStorage, mqttService: mqtt);

      await sessionManager.logout();

      expect(mqtt.disconnectCalls, 1);
    });

    test('does not throw when no MQTT service is attached (mock mode)',
        () async {
      final sessionManager =
          SessionManager(tokenStorage: TokenStorage(_FakeSecureStorage()));

      await expectLater(sessionManager.logout(), completes);
    });

    test('concurrent logout calls only run the clear/notify sequence once',
        () async {
      final tokenStorage = TokenStorage(_FakeSecureStorage());
      final mqtt = _SpyMqttService();
      final sessionManager =
          SessionManager(tokenStorage: tokenStorage, mqttService: mqtt);

      var expiredCalls = 0;
      sessionManager.onSessionExpired = () => expiredCalls++;

      // Simulates a manual logout tap racing with a 401-triggered logout
      // from an in-flight request.
      await Future.wait([sessionManager.logout(), sessionManager.logout()]);

      expect(expiredCalls, 1);
      expect(mqtt.disconnectCalls, 1);
    });
  });
}
