import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_settings.dart';

abstract class SecurityEventRepository {
  Future<List<SecurityEvent>> getSecurityEvents();

  Future<List<int>?> exportCsv();

  Future<SecuritySettings> getSettings();
  Future<void> updateSettings(Map<String, dynamic> data);
  Future<void> toggleZoneDetection(String zoneId, bool enabled);
}
