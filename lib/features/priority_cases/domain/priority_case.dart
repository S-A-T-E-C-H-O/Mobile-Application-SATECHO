class PriorityCase {
  const PriorityCase({
    required this.alertId,
    required this.farmerName,
    required this.farmName,
    required this.alertType,
    required this.severity,
    required this.createdAt,
  });

  final int alertId;
  final String? farmerName;
  final String? farmName;
  final String alertType;
  final String severity;
  final DateTime? createdAt;

  String get elapsedLabel {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
