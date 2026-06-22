import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_draft.dart';

abstract class AgronomistRecommendationRepository {
  Future<List<AgronomistRecommendation>> getAgronomistRecommendations();
  Future<void> createRecommendation(RecommendationDraft draft);
}
