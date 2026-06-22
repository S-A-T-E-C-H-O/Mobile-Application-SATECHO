import 'package:satecho_mobile/features/advisory/domain/recommendation_priority.dart';

class Recommendation {
  const Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.dateLabel,
    required this.plotName,
    required this.author,
    required this.priority,
    required this.canComplete,
  });

  final String id;
  final String title;
  final String description;
  final String dateLabel;
  final String plotName;
  final String author;
  final RecommendationPriority priority;
  final bool canComplete;
}
