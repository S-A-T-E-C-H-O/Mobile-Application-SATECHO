enum SensorMetricType { humidity, temperature, electricalConductivity }

class SensorMetric {
  const SensorMetric({
    required this.type,
    required this.label,
    required this.numericValue,
    required this.displayValue,
  });

  final SensorMetricType type;
  final String label;
  final double numericValue;
  final String displayValue;
}
