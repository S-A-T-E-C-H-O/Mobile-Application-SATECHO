import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/domain/dashboard_repository.dart';

class GetFarmerDashboard {
  const GetFarmerDashboard(this._repository);

  final DashboardRepository _repository;

  Future<FarmerDashboard> call() => _repository.getFarmerDashboard();
}
