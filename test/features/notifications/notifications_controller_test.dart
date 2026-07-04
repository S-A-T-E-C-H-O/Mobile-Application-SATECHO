import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/features/notifications/domain/alert_severity.dart';
import 'package:satecho_mobile/features/notifications/domain/app_notification.dart';
import 'package:satecho_mobile/features/notifications/domain/notification_center_repository.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/get_notifications.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/mark_notification_read.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/notifications_controller.dart';

class _FakeRepository implements NotificationCenterRepository {
  _FakeRepository(this.notifications);

  List<AppNotification> notifications;
  bool markAsReadShouldFail = false;
  String? lastMarkedId;

  @override
  Future<List<AppNotification>> getAll({bool? read}) async => notifications;

  @override
  Future<void> markAsRead(String notificationId) async {
    lastMarkedId = notificationId;
    if (markAsReadShouldFail) throw Exception('network error');
  }
}

AppNotification _n(int id,
    {bool read = false, DateTime? sentAt, String type = 'IRRIGATION_ALERT'}) {
  return AppNotification(
    id: id,
    type: type,
    title: 'Notification $id',
    body: 'Body $id',
    read: read,
    severity: AlertSeverity.critical,
    timeLabel: 'now',
    sentAt: sentAt ?? DateTime(2026, 1, id),
  );
}

void main() {
  group('NotificationsController', () {
    test('load sorts notifications by sentAt descending', () async {
      final repo = _FakeRepository([_n(1), _n(3), _n(2)]);
      final controller = NotificationsController(
        GetNotifications(repo),
        MarkNotificationRead(repo),
      );

      await controller.load();

      expect(controller.notifications.map((n) => n.id).toList(), [3, 2, 1]);
      expect(controller.isLoading, isFalse);
    });

    test('unreadCount counts only unread notifications', () async {
      final repo = _FakeRepository([_n(1, read: true), _n(2), _n(3)]);
      final controller = NotificationsController(
          GetNotifications(repo), MarkNotificationRead(repo));

      await controller.load();

      expect(controller.unreadCount, 2);
    });

    test('markAsRead updates local state optimistically and calls repository',
        () async {
      final repo = _FakeRepository([_n(1)]);
      final controller = NotificationsController(
          GetNotifications(repo), MarkNotificationRead(repo));
      await controller.load();

      await controller.markAsRead(1);

      expect(controller.notifications.first.read, isTrue);
      expect(repo.lastMarkedId, '1');
    });

    test('markAsRead reverts local state if the repository call fails',
        () async {
      final repo = _FakeRepository([_n(1)])..markAsReadShouldFail = true;
      final controller = NotificationsController(
          GetNotifications(repo), MarkNotificationRead(repo));
      await controller.load();

      await controller.markAsRead(1);

      expect(controller.notifications.first.read, isFalse);
    });

    test('setTypeFilter narrows the filtered list', () async {
      final repo = _FakeRepository([
        _n(1, type: 'IRRIGATION_ALERT'),
        _n(2, type: 'SECURITY_ALERT'),
      ]);
      final controller = NotificationsController(
          GetNotifications(repo), MarkNotificationRead(repo));
      await controller.load();

      controller.setTypeFilter('SECURITY_ALERT');

      expect(controller.filtered.map((n) => n.id).toList(), [2]);
    });
  });
}
