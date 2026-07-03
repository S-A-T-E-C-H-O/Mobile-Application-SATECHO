import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';

abstract class SecurityEventRepository {
  Future<List<SecurityEvent>> getSecurityEvents();

  /// EP-003-US002 Scenario 3: raw CSV bytes for the farmer's security event
  /// history, or null if unavailable (mock mode / no farms / request failure).
  Future<List<int>?> exportCsv();
}
