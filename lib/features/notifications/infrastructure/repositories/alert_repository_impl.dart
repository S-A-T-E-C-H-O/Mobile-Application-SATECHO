import '../../domain/entities/farm_alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../data_sources/remote/alert_remote_data_source.dart';

class AlertRepositoryImpl implements AlertRepository {
  const AlertRepositoryImpl(this._remote);

  final AlertRemoteDataSource _remote;

  @override
  Future<List<FarmAlert>> getActiveAlerts() async {
    final models = await _remote.getNotifications(read: false);
    return models
        .map((m) => FarmAlert(
              id: m.id.toString(),
              title: m.title,
              plotId: m.relatedEntityId?.toString() ?? '',
              plotName: m.relatedEntityType == 'ZONE'
                  ? 'Zone ${m.relatedEntityId}'
                  : 'Farm',
              timeLabel: m.timeLabel,
              severity: m.severity,
            ))
        .toList();
  }

  @override
  Future<void> markResolved(String alertId) async {
    await _remote.markRead(alertId);
  }
}
