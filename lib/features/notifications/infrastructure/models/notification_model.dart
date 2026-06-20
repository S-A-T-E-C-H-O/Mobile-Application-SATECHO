import '../../domain/value_objects/alert_severity.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.read,
    this.relatedEntityId,
    this.relatedEntityType,
    this.sentAt,
  });

  final int id;
  final String type;
  final String title;
  final String body;
  final bool read;
  final int? relatedEntityId;
  final String? relatedEntityType;
  final DateTime? sentAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? 'INFO',
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      read: json['read'] as bool? ?? false,
      relatedEntityId: json['relatedEntityId'] as int?,
      relatedEntityType: json['relatedEntityType'] as String?,
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
    );
  }

  AlertSeverity get severity {
    final t = type.toUpperCase();
    if (t.contains('CRITICAL')) return AlertSeverity.critical;
    if (t.contains('WARNING') || t.contains('ALERT')) return AlertSeverity.warning;
    return AlertSeverity.info;
  }

  String get timeLabel {
    if (sentAt == null) return 'Unknown';
    final diff = DateTime.now().difference(sentAt!);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays} days ago';
  }
}
