import 'package:satecho_mobile/features/notifications/domain/agronomist_alert.dart';
import 'package:satecho_mobile/features/notifications/domain/agronomist_alert_repository.dart';
import 'package:satecho_mobile/features/notifications/data/alert_remote_data_source.dart';

class AgronomistAlertRepositoryImpl implements AgronomistAlertRepository {
  const AgronomistAlertRepositoryImpl(this._remote);

  final AlertRemoteDataSource _remote;

  @override
  Future<List<AgronomistAlert>> getAgronomistAlerts() async {
    try {
      final notifications = await _remote.getNotifications(read: false);
      return notifications
          .map((n) => AgronomistAlert(
                id: n.id.toString(),
                farmName: n.relatedEntityType == 'FARM'
                    ? 'Farm #${n.relatedEntityId}'
                    : 'Farm',
                zoneName: n.relatedEntityType == 'ZONE'
                    ? 'Zone #${n.relatedEntityId}'
                    : 'General',
                title: n.title,
                timeLabel: n.timeLabel,
                severity: _severityLabel(n.type),
              ))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  String _severityLabel(String type) {
    final t = type.toUpperCase();
    if (t.contains('CRITICAL')) return 'critical';
    if (t.contains('WARNING') || t.contains('ALERT')) return 'attention';
    return 'info';
  }
}
