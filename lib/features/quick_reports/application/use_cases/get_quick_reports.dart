import 'package:satecho_mobile/features/quick_reports/domain/entities/quick_report.dart';
import 'package:satecho_mobile/features/quick_reports/domain/repositories/quick_report_repository.dart';

class GetQuickReports {
  const GetQuickReports(this._repository);

  final QuickReportRepository _repository;

  Future<List<QuickReport>> call() => _repository.getQuickReports();
}
