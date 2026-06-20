import '../entities/agronomist_alert.dart';

abstract class AgronomistAlertRepository {
  Future<List<AgronomistAlert>> getAgronomistAlerts();
}
