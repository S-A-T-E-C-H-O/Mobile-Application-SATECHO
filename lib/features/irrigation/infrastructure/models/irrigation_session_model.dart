import '../../domain/entities/irrigation_session.dart';

class IrrigationSessionModel {
  const IrrigationSessionModel({
    required this.id,
    required this.zoneId,
    required this.status,
    this.startedAt,
    this.durationMinutes,
  });

  final int id;
  final int zoneId;
  final String status;
  final DateTime? startedAt;
  final int? durationMinutes;

  factory IrrigationSessionModel.fromJson(Map<String, dynamic> json) {
    return IrrigationSessionModel(
      id: json['id'] as int,
      zoneId: json['zoneId'] as int,
      status: json['status'] as String,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      durationMinutes: json['durationMinutes'] as int?,
    );
  }

  IrrigationSession toEntity() {
    final isRunning = status.toUpperCase() == 'RUNNING';
    int? remaining;
    if (isRunning && startedAt != null && durationMinutes != null) {
      final elapsed = DateTime.now().difference(startedAt!).inMinutes;
      remaining = (durationMinutes! - elapsed).clamp(0, durationMinutes!);
    }
    return IrrigationSession(
      plotId: zoneId.toString(),
      status: isRunning
          ? IrrigationSessionStatus.running
          : IrrigationSessionStatus.idle,
      selectedDurationMinutes: durationMinutes ?? 0,
      remainingMinutes: remaining,
    );
  }

  static IrrigationSession idle(String plotId) {
    return IrrigationSession(
      plotId: plotId,
      status: IrrigationSessionStatus.idle,
      selectedDurationMinutes: 0,
    );
  }

  static IrrigationSession mock({
    required String plotId,
    IrrigationSessionStatus status = IrrigationSessionStatus.idle,
    int selectedDurationMinutes = 15,
    int? remainingMinutes,
  }) {
    return IrrigationSession(
      plotId: plotId,
      status: status,
      selectedDurationMinutes: selectedDurationMinutes,
      remainingMinutes: remainingMinutes,
    );
  }
}
