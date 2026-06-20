import '../entities/farmer_dashboard.dart';

abstract class DashboardRepository {
  Future<FarmerDashboard> getFarmerDashboard();
}
