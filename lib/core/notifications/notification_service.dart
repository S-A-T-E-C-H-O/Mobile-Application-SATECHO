import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/notifications/data/device_token_remote_data_source.dart';

/// Handles FCM permission requests, token registration, and foreground
/// message delivery for critical alert push notifications (EP-008-US020).
///
/// All Firebase calls are wrapped defensively: this repo does not ship real
/// Firebase project credentials (google-services.json / GoogleService-Info.plist),
/// so in local/dev builds every method degrades to a no-op instead of crashing.
class NotificationService {
  NotificationService({required DeviceTokenRemoteDataSource remote})
      : _remote = remote;

  final DeviceTokenRemoteDataSource _remote;

  Future<void> initialize() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    } catch (e) {
      debugPrint('NotificationService.initialize skipped: $e');
    }
  }

  /// Fetches the device's FCM token and registers it with the backend so
  /// push notifications can be routed to this device (call after login).
  Future<void> registerDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _remote.register(fcmToken: token, platform: _platformName());
    } catch (e) {
      debugPrint('registerDeviceToken skipped: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground push received: ${message.notification?.title}');
  }

  String _platformName() {
    if (kIsWeb) return 'WEB';
    if (Platform.isAndroid) return 'ANDROID';
    if (Platform.isIOS) return 'IOS';
    return 'OTHER';
  }
}

/// Must be a top-level function (background isolate entry point).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background push received: ${message.notification?.title}');
}
