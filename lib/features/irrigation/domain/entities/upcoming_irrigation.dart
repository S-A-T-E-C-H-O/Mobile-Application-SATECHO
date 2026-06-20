class UpcomingIrrigation {
  const UpcomingIrrigation({
    required this.id,
    required this.plotId,
    required this.plotName,
    required this.scheduleLabel,
    required this.durationMinutes,
    required this.highlighted,
  });

  final String id;
  final String plotId;
  final String plotName;
  final String scheduleLabel;
  final int durationMinutes;
  final bool highlighted;

  UpcomingIrrigation copyWith({bool? highlighted}) {
    return UpcomingIrrigation(
      id: id,
      plotId: plotId,
      plotName: plotName,
      scheduleLabel: scheduleLabel,
      durationMinutes: durationMinutes,
      highlighted: highlighted ?? this.highlighted,
    );
  }
}
