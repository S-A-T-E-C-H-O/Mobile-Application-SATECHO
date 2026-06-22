import 'package:satecho_mobile/features/advisory/domain/recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_repository.dart';

class GetRecommendations {
  const GetRecommendations(this._repository);

  final RecommendationRepository _repository;

  Future<List<Recommendation>> call() => _repository.getRecommendations();
}
