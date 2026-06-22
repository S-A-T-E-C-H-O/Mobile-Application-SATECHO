import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';

class FarmActivity {
  const FarmActivity({
    required this.id,
    required this.plotId,
    required this.type,
    required this.createdAt,
    required this.pendingSync,
  });

  final String id;
  final String plotId;
  final ActivityType type;
  final DateTime createdAt;
  final bool pendingSync;
}
