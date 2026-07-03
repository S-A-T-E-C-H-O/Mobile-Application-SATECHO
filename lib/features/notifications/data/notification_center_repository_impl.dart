import 'package:satecho_mobile/features/notifications/data/alert_remote_data_source.dart';
import 'package:satecho_mobile/features/notifications/domain/app_notification.dart';
import 'package:satecho_mobile/features/notifications/domain/notification_center_repository.dart';

class NotificationCenterRepositoryImpl implements NotificationCenterRepository {
  const NotificationCenterRepositoryImpl(this._remote);

  final AlertRemoteDataSource _remote;

  @override
  Future<List<AppNotification>> getAll({bool? read}) async {
    final models = await _remote.getNotifications(read: read);
    return models
        .map((m) => AppNotification(
              id: m.id,
              type: m.type,
              title: m.title,
              body: m.body,
              read: m.read,
              severity: m.severity,
              timeLabel: m.timeLabel,
              relatedEntityId: m.relatedEntityId,
              relatedEntityType: m.relatedEntityType,
              sentAt: m.sentAt,
            ))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _remote.markRead(notificationId);
  }
}
