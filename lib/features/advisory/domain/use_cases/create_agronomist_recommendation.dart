import 'package:satecho_mobile/features/advisory/domain/recommendation_draft.dart';
import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation_repository.dart';

class CreateAgronomistRecommendation {
  const CreateAgronomistRecommendation(this._repository);

  final AgronomistRecommendationRepository _repository;

  Future<void> call(RecommendationDraft draft) {
    return _repository.createRecommendation(draft);
  }
}
