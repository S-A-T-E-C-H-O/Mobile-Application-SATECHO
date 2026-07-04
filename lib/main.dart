import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    // No Firebase project configured for this environment (missing
    // google-services.json / GoogleService-Info.plist) — push notifications
    // degrade to a no-op instead of crashing app startup.
    debugPrint('Firebase initialization skipped: $e');
  }
  runApp(const SatechoApp());
}
