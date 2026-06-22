import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';

class ActivityDraftDto {
  const ActivityDraftDto({
    required this.plotId,
    required this.plotName,
    required this.type,
  });

  final String plotId;
  final String plotName;
  final ActivityType type;
}
