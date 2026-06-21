class SecurityEvent {
  const SecurityEvent({
    required this.id,
    required this.title,
    required this.zoneId,
    required this.zoneName,
    required this.createdAt,
    required this.classification,
  });

  final String id;
  final String title;
  final String zoneId;
  final String zoneName;
  final DateTime createdAt;
  final String classification;
}
