import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_draft.dart';
import 'package:satecho_mobile/features/advisory/domain/agronomist_recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/data/recommendation_remote_data_source.dart';

class AgronomistRecommendationRepositoryImpl
    implements AgronomistRecommendationRepository {
  const AgronomistRecommendationRepositoryImpl(this._remote);

  final RecommendationRemoteDataSource _remote;

  @override
  Future<List<AgronomistRecommendation>> getAgronomistRecommendations() async {
    try {
      final models = await _remote.getRecommendations();
      return models
          .map((m) => AgronomistRecommendation(
                id: m.id.toString(),
                farmName: 'Farm',
                zoneName: m.zoneId != null ? 'Zone ${m.zoneId}' : 'General',
                problem: m.description,
                priority: m.priority,
                status: m.status,
              ))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> createRecommendation(RecommendationDraft draft) async {
    final description = [
      if (draft.product.isNotEmpty) 'Product/action: ${draft.product}',
      if (draft.dose.isNotEmpty) 'Dose: ${draft.dose}',
      if (draft.suggestedDate.isNotEmpty)
        'Suggested date: ${draft.suggestedDate}',
    ].join('. ');
    // Backend only models MEDIUM/HIGH priority — the mobile wizard's "Low"
    // option maps to MEDIUM since there's no lower tier server-side.
    final priority = draft.priority.toUpperCase() == 'HIGH' ? 'HIGH' : 'MEDIUM';
    await _remote.createRecommendation(
      farmerId: draft.farmerId,
      zoneId: int.tryParse(draft.zoneId),
      title: draft.problem,
      description: description.isEmpty ? draft.problem : description,
      recommendedActions: draft.product.isEmpty ? null : draft.product,
      priority: priority,
    );
  }
}
