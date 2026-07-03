import 'package:satecho_mobile/features/notifications/domain/app_notification.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_severity.dart';
import 'package:satecho_mobile/features/notifications/domain/notification_center_repository.dart';

class MockNotificationCenterRepository implements NotificationCenterRepository {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 1,
      type: 'IRRIGATION_ALERT',
      title: 'Water stress alert',
      body: 'Water stress in Plot 1 North: soil moisture at 15.0%.',
      read: false,
      severity: AlertSeverity.critical,
      timeLabel: 'Now',
      relatedEntityId: 1,
      relatedEntityType: 'ALERT',
      sentAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AppNotification(
      id: 2,
      type: 'SECURITY_ALERT',
      title: 'Intrusion alert',
      body: 'Person detected in Zone 3',
      read: false,
      severity: AlertSeverity.critical,
      timeLabel: '2h',
      relatedEntityId: 2,
      relatedEntityType: 'SECURITY_EVENT',
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: 3,
      type: 'SYSTEM',
      title: 'Irrigation completed',
      body: 'Scheduled irrigation finished for Plot 3 East.',
      read: true,
      severity: AlertSeverity.info,
      timeLabel: 'yesterday',
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<AppNotification>> getAll({bool? read}) async {
    if (read == null) return List.unmodifiable(_notifications);
    return _notifications.where((n) => n.read == read).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final id = int.tryParse(notificationId);
    for (var i = 0; i < _notifications.length; i++) {
      if (_notifications[i].id == id) {
        _notifications[i] = _notifications[i].copyWith(read: true);
        return;
      }
    }
  }
}
