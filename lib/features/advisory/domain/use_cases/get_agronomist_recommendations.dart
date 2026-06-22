import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation_repository.dart';

class GetAgronomistRecommendations {
  const GetAgronomistRecommendations(this._repository);

  final AgronomistRecommendationRepository _repository;

  Future<List<AgronomistRecommendation>> call() {
    return _repository.getAgronomistRecommendations();
  }
}
