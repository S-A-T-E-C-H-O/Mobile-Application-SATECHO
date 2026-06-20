import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/zones/domain/use_cases/get_zone_by_id.dart';
import 'package:satecho_mobile/features/zones/domain/zone.dart';

class ZoneAnalysisController extends ChangeNotifier {
  ZoneAnalysisController(this._getZoneById);

  final GetZoneById _getZoneById;

  bool isLoading = true;
  Zone? zone;

  Future<void> load(String zoneId) async {
    isLoading = true;
    notifyListeners();
    zone = await _getZoneById(zoneId);
    isLoading = false;
    notifyListeners();
  }
}
