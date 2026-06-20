import '../../domain/entities/agronomist_alert.dart';
import '../../domain/repositories/agronomist_alert_repository.dart';

class MockAgronomistAlertRepository implements AgronomistAlertRepository {
  @override
  Future<List<AgronomistAlert>> getAgronomistAlerts() async {
    return const [
      AgronomistAlert(
          id: 'a1',
          farmName: 'Fundo San José',
          zoneName: 'Northern Sector',
          title: 'Severe Water Stress',
          timeLabel: '30 minutes ago',
          severity: 'critical'),
      AgronomistAlert(
          id: 'a2',
          farmName: 'Hacienda El Rosal',
          zoneName: 'Lote 4B',
          title: 'Drastic drop in NDVI',
          timeLabel: '1 hour ago',
          severity: 'critical'),
      AgronomistAlert(
          id: 'a3',
          farmName: 'Fundo Santa Clara',
          zoneName: 'Vivero 1',
          title: 'Temperature Anomaly',
          timeLabel: '3 hours ago',
          severity: 'attention'),
    ];
  }
}
