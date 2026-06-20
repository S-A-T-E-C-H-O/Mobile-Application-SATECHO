import '../../domain/entities/farm_alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../../domain/value_objects/alert_severity.dart';

class MockAlertRepository implements AlertRepository {
  final List<FarmAlert> _alerts = [
    const FarmAlert(
      id: 'alert-1',
      title: 'Estr\u00E9s h\u00EDdrico detectado',
      plotId: 'plot-1',
      plotName: 'Plot 1 North',
      timeLabel: 'Ahora',
      severity: AlertSeverity.critical,
    ),
    const FarmAlert(
      id: 'alert-salinity-1',
      title: 'Alerta Cr\u00EDtica: Alta salinidad detectada',
      plotId: 'plot-1',
      plotName: 'Plot 1 North',
      timeLabel: 'Ahora',
      severity: AlertSeverity.critical,
    ),
    const FarmAlert(
      id: 'alert-2',
      title: 'Posible riesgo de plagas',
      plotId: 'lot-b',
      plotName: 'Lot B South',
      timeLabel: '5h',
      severity: AlertSeverity.warning,
    ),
    const FarmAlert(
      id: 'alert-salinity-2',
      title: 'Alerta Cr\u00EDtica: Alta salinidad detectada',
      plotId: 'lot-b',
      plotName: 'Lot B South',
      timeLabel: '2h',
      severity: AlertSeverity.critical,
    ),
    const FarmAlert(
      id: 'alert-3',
      title: 'Riego programado completado',
      plotId: 'plot-3',
      plotName: 'Plot 3 East',
      timeLabel: 'hoy 06:00',
      severity: AlertSeverity.info,
    ),
  ];

  @override
  Future<List<FarmAlert>> getActiveAlerts() async => List.unmodifiable(_alerts);

  @override
  Future<void> markResolved(String alertId) async {
    _alerts.removeWhere((alert) => alert.id == alertId);
  }
}
