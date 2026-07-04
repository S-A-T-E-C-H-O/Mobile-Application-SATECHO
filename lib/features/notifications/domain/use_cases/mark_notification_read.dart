import 'package:satecho_mobile/features/notifications/domain/notification_center_repository.dart';

class MarkNotificationRead {
  const MarkNotificationRead(this._repository);

  final NotificationCenterRepository _repository;

  Future<void> call(String notificationId) => _repository.markAsRead(notificationId);
}
