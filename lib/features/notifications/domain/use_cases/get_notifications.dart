import 'package:satecho_mobile/features/notifications/domain/app_notification.dart';
import 'package:satecho_mobile/features/notifications/domain/notification_center_repository.dart';

class GetNotifications {
  const GetNotifications(this._repository);

  final NotificationCenterRepository _repository;

  Future<List<AppNotification>> call({bool? read}) =>
      _repository.getAll(read: read);
}
