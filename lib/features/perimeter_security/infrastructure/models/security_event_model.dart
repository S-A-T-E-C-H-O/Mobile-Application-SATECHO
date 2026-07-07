class SecurityEventModel {
  const SecurityEventModel({
    required this.id,
    required this.classification,
    required this.severity,
    required this.detectedAt,
    this.locationDescription,
    this.zoneId,
    this.pulseDurationMs,
    this.triggersPerMinute,
  });

  final int id;
  final String classification;
  final String severity;
  final DateTime detectedAt;
  final String? locationDescription;
  final int? zoneId;
  final double? pulseDurationMs;
  final int? triggersPerMinute;

  factory SecurityEventModel.fromJson(Map<String, dynamic> json) {
    return SecurityEventModel(
      id: json['id'] as int,
      classification: json['classification'] as String? ?? 'UNKNOWN',
      severity: json['severity'] as String? ?? 'LOW',
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      locationDescription: json['locationDescription'] as String?,
      zoneId: json['zoneId'] as int?,
      pulseDurationMs: (json['pulseDurationMs'] as num?)?.toDouble(),
      triggersPerMinute: json['triggersPerMinute'] as int?,
    );
  }
}
