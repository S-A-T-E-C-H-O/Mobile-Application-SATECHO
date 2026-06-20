import '../entities/farm_alert.dart';

abstract class AlertRepository {
  Future<List<FarmAlert>> getActiveAlerts();
  Future<void> markResolved(String alertId);
}
