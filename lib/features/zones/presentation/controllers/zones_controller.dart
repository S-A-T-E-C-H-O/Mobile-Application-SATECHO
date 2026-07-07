import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/zones/domain/use_cases/get_my_farm_id.dart';
import 'package:satecho_mobile/features/zones/domain/use_cases/get_zones_by_farm.dart';
import 'package:satecho_mobile/features/zones/domain/zone.dart';

class ZonesController extends ChangeNotifier {
  ZonesController(this._getMyFarmId, this._getZonesByFarm);

  final GetMyFarmId _getMyFarmId;
  final GetZonesByFarm _getZonesByFarm;

  bool isLoading = true;
  String? errorMessage;
  List<Zone> zones = [];
  String? farmId;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      farmId = await _getMyFarmId();
      if (farmId == null) {
        errorMessage = 'No se encontró una propiedad registrada.';
      } else {
        zones = await _getZonesByFarm(farmId!);
      }
    } catch (_) {
      errorMessage = 'No pudimos cargar las zonas de tu propiedad.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
