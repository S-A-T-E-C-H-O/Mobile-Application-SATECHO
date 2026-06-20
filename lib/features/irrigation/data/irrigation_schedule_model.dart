class IrrigationScheduleModel {
  const IrrigationScheduleModel({
    required this.id,
    required this.zoneId,
    required this.durationMinutes,
    required this.enabled,
    this.nextRunAt,
  });

  final int id;
  final int zoneId;
  final int durationMinutes;
  final bool enabled;
  final DateTime? nextRunAt;

  factory IrrigationScheduleModel.fromJson(Map<String, dynamic> json) {
    return IrrigationScheduleModel(
      id: json['id'] as int,
      zoneId: json['zoneId'] as int,
      durationMinutes: json['durationMinutes'] as int,
      enabled: json['enabled'] as bool? ?? true,
      nextRunAt: json['nextRunAt'] != null
          ? DateTime.parse(json['nextRunAt'] as String)
          : null,
    );
  }
}
