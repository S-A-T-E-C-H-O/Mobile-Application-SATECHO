import 'package:satecho_mobile/features/advisory/domain/recommendation.dart';

abstract class RecommendationRepository {
  Future<List<Recommendation>> getRecommendations();
  Future<void> markCompleted(String recommendationId);
}
