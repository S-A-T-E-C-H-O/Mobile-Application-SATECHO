import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/notifications/domain/use_cases/get_active_alerts.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/resolve_alert.dart';
import 'package:satecho_mobile/features/notifications/domain/farm_alert.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_severity.dart';

class AlertsController extends ChangeNotifier {
  AlertsController(this._getActiveAlerts, this._resolveAlert);

  final GetActiveAlerts _getActiveAlerts;
  final ResolveAlert _resolveAlert;

  bool isLoading = true;
  List<FarmAlert> alerts = [];

  int get unreadCount {
    return alerts.where((alert) => alert.severity != AlertSeverity.info).length;
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    alerts = await _getActiveAlerts();
    isLoading = false;
    notifyListeners();
  }

  Future<void> resolve(String alertId) async {
    await _resolveAlert(alertId);
    await load();
  }
}
