import 'package:satecho_mobile/features/advisory/domain/recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_repository.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_priority.dart';

class MockRecommendationRepository implements RecommendationRepository {
  final List<Recommendation> _items = [
    const Recommendation(
      id: 'rec-1',
      title: 'Apply irrigation to Plot 1',
      description:
          'Humidity below 45%. Water for 30 minutes.\nToday before 6:00 PM',
      dateLabel: 'Today',
      plotName: 'Plot 1 North',
      author: 'Eng. Martinez',
      priority: RecommendationPriority.high,
      canComplete: true,
    ),
    const Recommendation(
      id: 'rec-2',
      title: 'Monitor Lot B',
      description: 'Check lower leaves for spots.\nPossible rust',
      dateLabel: 'Tomorrow',
      plotName: 'Lot B South',
      author: 'AI System',
      priority: RecommendationPriority.medium,
      canComplete: true,
    ),
    const Recommendation(
      id: 'rec-3',
      title: 'Prepare Batch C',
      description: 'Land preparation for the next crop rotation.',
      dateLabel: 'This week',
      plotName: 'Lot C North',
      author: 'Eng. Rojas',
      priority: RecommendationPriority.medium,
      canComplete: false,
    ),
  ];

  @override
  Future<List<Recommendation>> getRecommendations() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<void> markCompleted(String recommendationId) async {
    _items.removeWhere((item) => item.id == recommendationId);
  }
}
