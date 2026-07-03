import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/advisory/domain/use_cases/create_agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_draft.dart';
import 'package:satecho_mobile/features/farms/domain/use_cases/get_assigned_clients.dart';
import 'package:satecho_mobile/features/farms/domain/assigned_client.dart';

class NewRecommendationController extends ChangeNotifier {
  NewRecommendationController(
      this._createRecommendation, this._getAssignedClients);

  final CreateAgronomistRecommendation _createRecommendation;
  final GetAssignedClients _getAssignedClients;

  int step = 0;
  String zoneId = '';
  int? farmerId;
  bool loadingClients = true;
  List<AssignedClient> clients = const [];
  String problem = 'Water stress';
  String product = '';
  String dose = '';
  String suggestedDate = '';
  String priority = 'Low';
  bool sent = false;

  bool get canGoNext {
    return switch (step) {
      0 => zoneId.isNotEmpty && farmerId != null,
      1 => problem.isNotEmpty,
      2 => true,
      3 => priority.isNotEmpty,
      _ => false,
    };
  }

  Future<void> loadClients() async {
    loadingClients = true;
    notifyListeners();
    clients = await _getAssignedClients();
    loadingClients = false;
    notifyListeners();
  }

  void selectZone(String zoneIdValue, int farmerIdValue) {
    zoneId = zoneIdValue;
    farmerId = farmerIdValue;
    step = 1;
    notifyListeners();
  }

  void selectProblem(String value) {
    problem = value;
    step = 2;
    notifyListeners();
  }

  void setProposal(
      {String? productValue, String? doseValue, String? dateValue}) {
    product = productValue ?? product;
    dose = doseValue ?? dose;
    suggestedDate = dateValue ?? suggestedDate;
  }

  void selectPriority(String value) {
    priority = value;
    notifyListeners();
  }

  void next() {
    if (step < 3) {
      step++;
      notifyListeners();
    }
  }

  Future<void> send() async {
    final resolvedFarmerId = farmerId;
    if (resolvedFarmerId == null) return;
    await _createRecommendation(
      RecommendationDraft(
        farmerId: resolvedFarmerId,
        zoneId: zoneId,
        problem: problem,
        product: product,
        dose: dose,
        suggestedDate: suggestedDate,
        priority: priority,
      ),
    );
    sent = true;
    notifyListeners();
  }
}
