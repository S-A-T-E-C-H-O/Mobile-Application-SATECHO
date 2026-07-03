import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';
import 'package:satecho_mobile/features/farms/domain/use_cases/get_assigned_clients.dart';
import 'package:satecho_mobile/features/parcel_comparison/domain/parcel_comparison.dart';
import 'package:satecho_mobile/features/parcel_comparison/domain/use_cases/compare_parcels.dart';

class ParcelComparisonController extends ChangeNotifier {
  ParcelComparisonController(this._compareParcels, this._getAssignedClients);

  static const maxSelectable = 4;

  final CompareParcels _compareParcels;
  final GetAssignedClients _getAssignedClients;

  bool loadingClients = true;
  List<AssignedClient> clients = const [];
  final Set<int> selectedZoneIds = {};

  bool loadingComparison = false;
  List<ParcelComparison> results = const [];
  String? error;

  Future<void> loadClients() async {
    loadingClients = true;
    notifyListeners();
    clients = await _getAssignedClients();
    loadingClients = false;
    notifyListeners();
  }

  void toggleZone(int zoneId) {
    if (selectedZoneIds.contains(zoneId)) {
      selectedZoneIds.remove(zoneId);
    } else {
      if (selectedZoneIds.length >= maxSelectable) {
        error = 'Maximum 4 parcels for comparison';
        notifyListeners();
        return;
      }
      selectedZoneIds.add(zoneId);
    }
    error = null;
    notifyListeners();
  }

  Future<void> compare() async {
    if (selectedZoneIds.isEmpty) return;
    loadingComparison = true;
    error = null;
    notifyListeners();
    try {
      results = await _compareParcels(selectedZoneIds.toList());
    } on Exception catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loadingComparison = false;
      notifyListeners();
    }
  }
}
