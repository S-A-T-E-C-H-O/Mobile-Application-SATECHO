import '../value_objects/alert_severity.dart';

class FarmAlert {
  const FarmAlert({
    required this.id,
    required this.title,
    required this.plotId,
    required this.plotName,
    required this.timeLabel,
    required this.severity,
  });

  final String id;
  final String title;
  final String plotId;
  final String plotName;
  final String timeLabel;
  final AlertSeverity severity;
}
