import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';

abstract class DashboardRepository {
  Future<FarmerDashboard> getFarmerDashboard();
}
