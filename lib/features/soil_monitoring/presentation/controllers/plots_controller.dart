import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/soil_monitoring/domain/use_cases/get_plots.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';

class PlotsController extends ChangeNotifier {
  PlotsController(this._getPlots);

  final GetPlots _getPlots;

  bool isLoading = true;
  String? errorMessage;
  List<Plot> plots = [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      plots = await _getPlots();
    } catch (_) {
      errorMessage = 'No pudimos cargar tus parcelas';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
