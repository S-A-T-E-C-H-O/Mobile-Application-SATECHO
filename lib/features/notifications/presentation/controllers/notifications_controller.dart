import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/notifications/domain/app_notification.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/get_notifications.dart';
import 'package:satecho_mobile/features/notifications/domain/use_cases/mark_notification_read.dart';

/// Backs the in-app notification center (EP-008-US021): chronological list,
/// mark-as-read, and an unread badge count for the navigation bar.
class NotificationsController extends ChangeNotifier {
  NotificationsController(this._getNotifications, this._markNotificationRead);

  final GetNotifications _getNotifications;
  final MarkNotificationRead _markNotificationRead;

  bool isLoading = true;
  List<AppNotification> notifications = [];
  String? typeFilter;

  int get unreadCount => notifications.where((n) => !n.read).length;

  List<AppNotification> get filtered {
    if (typeFilter == null) return notifications;
    return notifications.where((n) => n.type == typeFilter).toList();
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final all = List<AppNotification>.of(await _getNotifications());
    all.sort(
        (a, b) => (b.sentAt ?? DateTime(0)).compareTo(a.sentAt ?? DateTime(0)));
    notifications = all;
    isLoading = false;
    notifyListeners();
  }

  void setTypeFilter(String? type) {
    typeFilter = type;
    notifyListeners();
  }

  Future<void> markAsRead(int notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1 || notifications[index].read) return;

    final previous = notifications[index];
    notifications[index] = previous.copyWith(read: true);
    notifyListeners();

    try {
      await _markNotificationRead(notificationId.toString());
    } catch (_) {
      notifications[index] = previous;
      notifyListeners();
    }
  }
}
