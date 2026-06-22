import 'package:satecho_mobile/features/activity_log/domain/activity_draft.dart';
import 'package:satecho_mobile/features/activity_log/domain/farm_activity.dart';

abstract class ActivityRepository {
  Future<FarmActivity> saveOffline(ActivityDraft draft);
}
