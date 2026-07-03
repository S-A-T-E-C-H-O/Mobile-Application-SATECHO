import 'package:satecho_mobile/features/notifications/domain/alert_severity.dart';

/// A single entry in the farmer's in-app notification center (EP-008-US021).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.read,
    required this.severity,
    required this.timeLabel,
    this.relatedEntityId,
    this.relatedEntityType,
    this.sentAt,
  });

  final int id;
  final String type;
  final String title;
  final String body;
  final bool read;
  final AlertSeverity severity;
  final String timeLabel;
  final int? relatedEntityId;
  final String? relatedEntityType;
  final DateTime? sentAt;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      read: read ?? this.read,
      severity: severity,
      timeLabel: timeLabel,
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
      sentAt: sentAt,
    );
  }
}
