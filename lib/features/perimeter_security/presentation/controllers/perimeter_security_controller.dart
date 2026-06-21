import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/features/perimeter_security/application/uses_cases/get_security_events.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';

class PerimeterSecurityController extends ChangeNotifier {
  PerimeterSecurityController({
    required GetSecurityEvents getSecurityEvents,
    RealtimeService? realtime,
  })  : _getSecurityEvents = getSecurityEvents,
        _realtime = realtime;

  final GetSecurityEvents _getSecurityEvents;
  final RealtimeService? _realtime;

  StreamSubscription<RealtimeEvent>? _securitySub;

  bool isLoading = true;
  List<SecurityEvent> events = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    events = await _getSecurityEvents();
    isLoading = false;
    notifyListeners();
    _subscribeToSecurityEvents();
  }

  void _subscribeToSecurityEvents() {
    _securitySub?.cancel();
    final realtime = _realtime;
    if (realtime == null) return;

    _securitySub = realtime.securityEvents().listen((event) {
      if (event.securityEvent != null) {
        events = [event.securityEvent!, ...events];
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _securitySub?.cancel();
    super.dispose();
  }
}
