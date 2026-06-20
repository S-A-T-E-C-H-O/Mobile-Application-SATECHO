class WeatherSummary {
  const WeatherSummary({
    required this.temperature,
    required this.condition,
    required this.hasAlert,
  });

  final int temperature;
  final String condition;
  final bool hasAlert;
}
