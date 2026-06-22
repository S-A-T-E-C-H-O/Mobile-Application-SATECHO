import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/advisory/domain/use_cases/get_recommendations.dart';
import 'package:satecho_mobile/features/advisory/domain/use_cases/mark_recommendation_completed.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation.dart';

class RecommendationsController extends ChangeNotifier {
  RecommendationsController(this._getRecommendations, this._markCompleted);

  final GetRecommendations _getRecommendations;
  final MarkRecommendationCompleted _markCompleted;

  bool isLoading = true;
  List<Recommendation> recommendations = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    recommendations = await _getRecommendations();
    isLoading = false;
    notifyListeners();
  }

  Future<void> complete(String recommendationId) async {
    await _markCompleted(recommendationId);
    await load();
  }
}
