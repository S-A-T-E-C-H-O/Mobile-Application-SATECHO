import 'package:flutter/foundation.dart';

import '../../application/use_cases/get_plots.dart';
import '../../domain/entities/plot.dart';

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
      errorMessage = 'Could not load plots';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
