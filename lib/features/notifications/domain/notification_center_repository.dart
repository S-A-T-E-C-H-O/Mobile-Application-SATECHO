import 'package:satecho_mobile/features/notifications/domain/app_notification.dart';

abstract class NotificationCenterRepository {
  Future<List<AppNotification>> getAll({bool? read});
  Future<void> markAsRead(String notificationId);
}
