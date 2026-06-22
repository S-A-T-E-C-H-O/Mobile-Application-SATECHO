import 'package:satecho_mobile/features/advisory/domain/recommendation_priority.dart';

class RecommendationModel {
  const RecommendationModel({
    required this.id,
    required this.zoneId,
    required this.agronomistId,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    this.recommendedActions,
    this.generatedAt,
  });

  final int id;
  final int? zoneId;
  final int? agronomistId;
  final String priority;
  final String status;
  final String title;
  final String description;
  final String? recommendedActions;
  final DateTime? generatedAt;

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as int,
      zoneId: json['zoneId'] as int?,
      agronomistId: json['agronomistId'] as int?,
      priority: json['priority'] as String? ?? 'MEDIUM',
      status: json['status'] as String? ?? 'SENT',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      recommendedActions: json['recommendedActions'] as String?,
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'] as String)
          : null,
    );
  }

  RecommendationPriority get priorityValue {
    return priority.toUpperCase() == 'HIGH'
        ? RecommendationPriority.high
        : RecommendationPriority.medium;
  }

  bool get canComplete {
    final s = status.toUpperCase();
    return s == 'SENT' || s == 'PENDING';
  }

  String get dateLabel {
    if (generatedAt == null) return 'Unknown';
    final diff = DateTime.now().difference(generatedAt!);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays} days ago';
  }
}
