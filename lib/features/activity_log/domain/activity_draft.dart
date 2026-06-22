import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';

class ActivityDraft {
  const ActivityDraft({
    required this.plotId,
    required this.plotName,
    required this.type,
    required this.dateTimeLabel,
    this.photoPath,
  });

  final String plotId;
  final String plotName;
  final ActivityType type;
  final String dateTimeLabel;
  final String? photoPath;
}
