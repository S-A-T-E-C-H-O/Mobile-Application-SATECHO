import 'package:satecho_mobile/features/notifications/domain/farm_alert.dart';

abstract class AlertRepository {
  Future<List<FarmAlert>> getActiveAlerts();
  Future<void> markResolved(String alertId);
}
