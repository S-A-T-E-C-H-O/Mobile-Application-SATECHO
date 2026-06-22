import 'package:satecho_mobile/features/advisory/domain/recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/data/recommendation_remote_data_source.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  const RecommendationRepositoryImpl(this._remote);

  final RecommendationRemoteDataSource _remote;

  @override
  Future<List<Recommendation>> getRecommendations() async {
    final models = await _remote.getRecommendations();
    return models
        .map((m) => Recommendation(
              id: m.id.toString(),
              title: m.title,
              description: m.recommendedActions != null
                  ? '${m.description}\n\n${m.recommendedActions}'
                  : m.description,
              dateLabel: m.dateLabel,
              plotName: m.zoneId != null ? 'Zone ${m.zoneId}' : 'General',
              author: m.agronomistId != null
                  ? 'Agronomist #${m.agronomistId}'
                  : 'System',
              priority: m.priorityValue,
              canComplete: m.canComplete,
            ))
        .toList();
  }

  @override
  Future<void> markCompleted(String recommendationId) async {
    await _remote.acknowledge(recommendationId);
  }
}
