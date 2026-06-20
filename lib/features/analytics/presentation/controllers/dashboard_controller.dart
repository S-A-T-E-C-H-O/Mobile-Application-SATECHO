import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/analytics/domain/use_cases/get_farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';

class DashboardController extends ChangeNotifier {
  DashboardController(this._getFarmerDashboard);

  final GetFarmerDashboard _getFarmerDashboard;

  bool isLoading = true;
  FarmerDashboard? dashboard;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    dashboard = await _getFarmerDashboard();
    isLoading = false;
    notifyListeners();
  }
}
