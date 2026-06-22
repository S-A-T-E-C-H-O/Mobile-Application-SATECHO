import 'package:satecho_mobile/features/activity_log/domain/activity_draft.dart';
import 'package:satecho_mobile/features/activity_log/domain/farm_activity.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_repository.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';
import 'package:satecho_mobile/features/activity_log/data/activity_remote_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl(this._remote);

  final ActivityRemoteDataSource _remote;

  @override
  Future<FarmActivity> saveOffline(ActivityDraft draft) async {
    final typeStr = _toBackendType(draft.type);
    final json = await _remote.logActivity(
      zoneId: draft.plotId,
      type: typeStr,
    );
    return FarmActivity(
      id: json['id'].toString(),
      plotId: json['zoneId'].toString(),
      type: draft.type,
      createdAt: json['activityAt'] != null
          ? DateTime.parse(json['activityAt'] as String)
          : DateTime.now(),
      pendingSync: false,
    );
  }

  String _toBackendType(ActivityType type) {
    return switch (type) {
      ActivityType.manualWatering => 'MANUAL_WATERING',
      ActivityType.fertilizer => 'FERTILIZER',
      ActivityType.pestControl => 'PEST_CONTROL',
      ActivityType.observation => 'OBSERVATION',
    };
  }
}
