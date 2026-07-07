import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/core/realtime/realtime_placeholder.dart';
import 'package:satecho_mobile/features/perimeter_security/application/uses_cases/get_security_events.dart';
import 'package:satecho_mobile/features/perimeter_security/application/uses_cases/security_settings_use_cases.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_settings.dart';

class PerimeterSecurityController extends ChangeNotifier {
  PerimeterSecurityController({
    required GetSecurityEvents getSecurityEvents,
    RealtimeService? realtime,
    Future<List<int>?> Function()? exportCsv,
    GetSecuritySettings? getSettings,
    UpdateSecuritySettings? updateSettings,
    ToggleZoneDetection? toggleZoneDetection,
  })  : _getSecurityEvents = getSecurityEvents,
        _realtime = realtime,
        _exportCsv = exportCsv,
        _getSettings = getSettings,
        _updateSettings = updateSettings,
        _toggleZoneDetection = toggleZoneDetection;

  final GetSecurityEvents _getSecurityEvents;
  final RealtimeService? _realtime;
  final Future<List<int>?> Function()? _exportCsv;
  final GetSecuritySettings? _getSettings;
  final UpdateSecuritySettings? _updateSettings;
  final ToggleZoneDetection? _toggleZoneDetection;

  Future<List<int>?> exportCsv() async => _exportCsv?.call();

  StreamSubscription<RealtimeEvent>? _securitySub;

  bool isLoading = true;
  List<SecurityEvent> events = [];

  SecuritySettings? settings;
  bool isLoadingSettings = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    events = await _getSecurityEvents();
    isLoading = false;
    notifyListeners();
    _subscribeToSecurityEvents();
  }

  Future<void> loadSettings() async {
    if (_getSettings == null) return;
    isLoadingSettings = true;
    notifyListeners();
    settings = await _getSettings.call();
    isLoadingSettings = false;
    notifyListeners();
  }

  Future<void> saveSettings(Map<String, dynamic> data) async {
    if (_updateSettings == null) return;
    await _updateSettings.call(data);
  }

  Future<void> toggleZone(String zoneId, bool enabled) async {
    if (_toggleZoneDetection == null) return;
    await _toggleZoneDetection.call(zoneId, enabled);
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
