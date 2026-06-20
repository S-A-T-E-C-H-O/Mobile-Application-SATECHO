enum IrrigationSessionStatus { idle, running }

class IrrigationSession {
  const IrrigationSession({
    required this.plotId,
    required this.status,
    required this.selectedDurationMinutes,
    this.remainingMinutes,
  });

  final String plotId;
  final IrrigationSessionStatus status;
  final int selectedDurationMinutes;
  final int? remainingMinutes;

  bool get isRunning => status == IrrigationSessionStatus.running;

  IrrigationSession copyWith({
    String? plotId,
    IrrigationSessionStatus? status,
    int? selectedDurationMinutes,
    int? remainingMinutes,
  }) {
    return IrrigationSession(
      plotId: plotId ?? this.plotId,
      status: status ?? this.status,
      selectedDurationMinutes:
          selectedDurationMinutes ?? this.selectedDurationMinutes,
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
    );
  }
}
