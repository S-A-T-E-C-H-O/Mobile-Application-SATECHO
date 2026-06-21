import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/devices/application/use_cases/get_all_devices.dart';
import 'package:satecho_mobile/features/devices/domain/entities/device.dart';

class DevicesController extends ChangeNotifier {
  DevicesController(this._getAllDevices);

  final GetAllDevices _getAllDevices;

  bool isLoading = true;
  String? errorMessage;
  String? statusFilter;
  List<Device> _all = [];

  List<Device> get devices => statusFilter == null
      ? _all
      : _all.where((d) => d.status == statusFilter).toList();

  int get onlineCount => _all.where((d) => d.isOnline).length;
  int get offlineCount => _all.where((d) => !d.isOnline).length;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      _all = await _getAllDevices();
      errorMessage = null;
    } catch (_) {
      errorMessage = 'No se pudo cargar los dispositivos';
    }
    isLoading = false;
    notifyListeners();
  }

  void setFilter(String? status) {
    statusFilter = status;
    notifyListeners();
  }
}
