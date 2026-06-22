import 'package:satecho_mobile/features/activity_log/domain/activity_draft.dart';
import 'package:satecho_mobile/features/activity_log/domain/farm_activity.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_repository.dart';

class MockActivityRepository implements ActivityRepository {
  final List<FarmActivity> _activities = [];

  @override
  Future<FarmActivity> saveOffline(ActivityDraft draft) async {
    final activity = FarmActivity(
      id: 'activity-${_activities.length + 1}',
      plotId: draft.plotId,
      type: draft.type,
      createdAt: DateTime.now(),
      pendingSync: true,
    );
    _activities.add(activity);
    return activity;
  }
}
