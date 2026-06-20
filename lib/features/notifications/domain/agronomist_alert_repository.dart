import 'package:satecho_mobile/features/notifications/domain/agronomist_alert.dart';

abstract class AgronomistAlertRepository {
  Future<List<AgronomistAlert>> getAgronomistAlerts();
}
