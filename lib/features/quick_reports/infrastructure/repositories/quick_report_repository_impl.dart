import 'package:satecho_mobile/features/quick_reports/domain/entities/quick_report.dart';
import 'package:satecho_mobile/features/quick_reports/domain/repositories/quick_report_repository.dart';
import 'package:satecho_mobile/features/quick_reports/infrastructure/data_sources/remote/quick_report_remote_data_source.dart';

class QuickReportRepositoryImpl implements QuickReportRepository {
  const QuickReportRepositoryImpl(this._remote);

  final QuickReportRemoteDataSource _remote;

  @override
  Future<List<QuickReport>> getQuickReports() async {
    try {
      final clients = await _remote.getClientsDetailed();
      return clients
          .map((c) => QuickReport(
                id: c.id.toString(),
                farmName: c.farmName ?? 'Farm #${c.farmId ?? c.id}',
                ownerName: c.farmerName ?? 'Farmer #${c.farmerId}',
                crop: c.cropType ?? 'Unknown',
                areaLabel: '${c.hectares.toStringAsFixed(0)} ha',
                alerts: _alertCount(c.soilHumidity),
                recommendations: 0,
                records: c.zoneCount,
                riskColor: _riskColor(c.soilHumidity),
              ))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  int _alertCount(double? humidity) {
    if (humidity == null) return 0;
    if (humidity < 30) return 2;
    if (humidity < 50) return 1;
    return 0;
  }

  String _riskColor(double? humidity) {
    if (humidity == null) return 'green';
    if (humidity < 30) return 'red';
    if (humidity < 50) return 'orange';
    return 'green';
  }
}
