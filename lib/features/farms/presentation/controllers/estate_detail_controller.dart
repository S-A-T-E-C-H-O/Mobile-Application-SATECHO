import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/farms/domain/use_cases/get_assigned_client_detail.dart';
import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';

class EstateDetailController extends ChangeNotifier {
  EstateDetailController(this._getDetail);

  final GetAssignedClientDetail _getDetail;

  bool isLoading = true;
  AssignedClient? client;

  Future<void> load(String farmId) async {
    isLoading = true;
    notifyListeners();
    client = await _getDetail(farmId);
    isLoading = false;
    notifyListeners();
  }
}
