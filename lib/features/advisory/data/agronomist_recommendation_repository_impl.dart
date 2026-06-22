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
    // POST to recommendations endpoint with draft data
    // The remote data source doesn't expose a create method yet — no-op for now.
  }
}
