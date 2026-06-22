import 'package:satecho_mobile/features/quick_reports/domain/entities/quick_report.dart';
import 'package:satecho_mobile/features/quick_reports/domain/repositories/quick_report_repository.dart';

class MockQuickReportRepository implements QuickReportRepository {
  @override
  Future<List<QuickReport>> getQuickReports() async {
    return const [
      QuickReport(
          id: 'report-1',
          farmName: 'El Porvenir',
          ownerName: 'Juan Pérez',
          crop: 'Corn',
          areaLabel: '240 ha',
          alerts: 2,
          recommendations: 2,
          records: 3,
          riskColor: 'red'),
      QuickReport(
          id: 'report-2',
          farmName: 'La Esperanza',
          ownerName: 'María Gómez',
          crop: 'Soy',
          areaLabel: '180 ha',
          alerts: 0,
          recommendations: 1,
          records: 2,
          riskColor: 'green'),
      QuickReport(
          id: 'report-3',
          farmName: 'San Miguel',
          ownerName: 'Carlos Ruiz',
          crop: 'Wheat',
          areaLabel: '320 ha',
          alerts: 1,
          recommendations: 0,
          records: 1,
          riskColor: 'orange'),
      QuickReport(
          id: 'report-4',
          farmName: 'Los Álamos',
          ownerName: 'Ana Torres',
          crop: 'Corn',
          areaLabel: '150 ha',
          alerts: 0,
          recommendations: 0,
          records: 1,
          riskColor: 'green'),
    ];
  }
}
