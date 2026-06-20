import '../../domain/entities/farmer_dashboard.dart';
import '../../domain/repositories/dashboard_repository.dart';

class GetFarmerDashboard {
  const GetFarmerDashboard(this._repository);

  final DashboardRepository _repository;

  Future<FarmerDashboard> call() => _repository.getFarmerDashboard();
}
