import 'package:satecho_mobile/features/advisory/domain/recommendation_repository.dart';

class MarkRecommendationCompleted {
  const MarkRecommendationCompleted(this._repository);

  final RecommendationRepository _repository;

  Future<void> call(String recommendationId) {
    return _repository.markCompleted(recommendationId);
  }
}
