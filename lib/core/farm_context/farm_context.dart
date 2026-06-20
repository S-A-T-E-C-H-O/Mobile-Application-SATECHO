class FarmContext {
  const FarmContext({
    required this.farmId,
    required this.farmName,
    this.selectedPlotId,
  });

  final String farmId;
  final String farmName;
  final String? selectedPlotId;
}
