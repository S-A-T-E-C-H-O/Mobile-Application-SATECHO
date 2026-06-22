import 'package:satecho_mobile/features/quick_reports/domain/entities/quick_report.dart';

abstract class QuickReportRepository {
  Future<List<QuickReport>> getQuickReports();
}
