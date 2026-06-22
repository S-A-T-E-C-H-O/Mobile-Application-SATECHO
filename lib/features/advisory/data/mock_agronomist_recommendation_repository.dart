import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_draft.dart';
import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation_repository.dart';

class MockAgronomistRecommendationRepository
    implements AgronomistRecommendationRepository {
  final List<AgronomistRecommendation> _items = [
    const AgronomistRecommendation(
      id: 'agr-rec-1',
      farmName: 'Estate El Recuerdo',
      zoneName: 'North Lot',
      problem: 'Water stress',
      priority: 'High',
      status: 'Pending',
    ),
  ];

  @override
  Future<void> createRecommendation(RecommendationDraft draft) async {
    _items.add(
      AgronomistRecommendation(
        id: 'agr-rec-${_items.length + 1}',
        farmName: 'Estate El Recuerdo',
        zoneName: draft.zoneId,
        problem: draft.problem,
        priority: draft.priority,
        status: 'Sent',
      ),
    );
  }

  @override
  Future<List<AgronomistRecommendation>> getAgronomistRecommendations() async {
    return List.unmodifiable(_items);
  }
}
