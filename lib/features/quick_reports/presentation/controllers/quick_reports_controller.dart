import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/quick_reports/application/use_cases/get_quick_reports.dart';
import 'package:satecho_mobile/features/quick_reports/domain/entities/quick_report.dart';

class QuickReportsController extends ChangeNotifier {
  QuickReportsController(this._getQuickReports);

  final GetQuickReports _getQuickReports;

  bool isLoading = true;
  List<QuickReport> reports = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    reports = await _getQuickReports();
    isLoading = false;
    notifyListeners();
  }
}
