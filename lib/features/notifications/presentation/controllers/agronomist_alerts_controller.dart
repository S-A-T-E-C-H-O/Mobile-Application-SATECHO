import 'package:flutter/foundation.dart';

import '../../application/use_cases/get_agronomist_alerts.dart';
import '../../domain/entities/agronomist_alert.dart';

class AgronomistAlertsController extends ChangeNotifier {
  AgronomistAlertsController(this._getAlerts);

  final GetAgronomistAlerts _getAlerts;

  bool isLoading = true;
  List<AgronomistAlert> alerts = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    alerts = await _getAlerts();
    isLoading = false;
    notifyListeners();
  }
}
