import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/advisory/domain/use_cases/create_agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_draft.dart';

class NewRecommendationController extends ChangeNotifier {
  NewRecommendationController(this._createRecommendation);

  final CreateAgronomistRecommendation _createRecommendation;

  int step = 0;
  String zoneId = 'R1';
  String problem = 'Water stress';
  String product = '';
  String dose = '';
  String suggestedDate = '';
  String priority = 'Low';
  bool sent = false;

  bool get canGoNext {
    return switch (step) {
      0 => zoneId.isNotEmpty,
      1 => problem.isNotEmpty,
      2 => true,
      3 => priority.isNotEmpty,
      _ => false,
    };
  }

  void selectZone(String value) {
    zoneId = value;
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
    await _createRecommendation(
      RecommendationDraft(
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
