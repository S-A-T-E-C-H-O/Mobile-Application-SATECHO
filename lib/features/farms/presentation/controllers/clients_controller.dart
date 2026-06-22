import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/farms/domain/use_cases/get_assigned_clients.dart';
import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';

class ClientsController extends ChangeNotifier {
  ClientsController(this._getAssignedClients);

  final GetAssignedClients _getAssignedClients;

  bool isLoading = true;
  List<AssignedClient> clients = [];
  String query = '';

  List<AssignedClient> get visibleClients {
    if (query.isEmpty) return clients;
    final lower = query.toLowerCase();
    return clients
        .where(
          (client) =>
              client.farm.name.toLowerCase().contains(lower) ||
              client.farm.ownerName.toLowerCase().contains(lower) ||
              client.farm.crop.toLowerCase().contains(lower),
        )
        .toList();
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    clients = await _getAssignedClients();
    isLoading = false;
    notifyListeners();
  }

  void search(String value) {
    query = value;
    notifyListeners();
  }
}
