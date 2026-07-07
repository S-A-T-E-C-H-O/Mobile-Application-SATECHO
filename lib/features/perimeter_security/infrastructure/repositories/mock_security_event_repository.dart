import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_settings.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/repositories/security_event_repository.dart';

class MockSecurityEventRepository implements SecurityEventRepository {
  static final _now = DateTime.now();

  @override
  Future<List<SecurityEvent>> getSecurityEvents() async => [
        SecurityEvent(
          id: 'sec-1',
          title: 'Person detected in Zona 1',
          zoneId: 'zone-1',
          zoneName: 'Zona 1',
          createdAt: _now.subtract(const Duration(minutes: 15)),
          classification: 'PERSON',
        ),
        SecurityEvent(
          id: 'sec-2',
          title: 'Animal movement in Zona 2',
          zoneId: 'zone-2',
          zoneName: 'Zona 2',
          createdAt: _now.subtract(const Duration(hours: 2)),
          classification: 'ANIMAL',
        ),
      ];

  @override
  Future<List<int>?> exportCsv() async => null;

  @override
  Future<SecuritySettings> getSettings() async => const SecuritySettings(
        id: 1,
        farmId: 1,
        motionSensitivity: 70,
        alertMode: 'MOTION_ONLY',
        detectionScheduleStart: '18:00',
        detectionScheduleEnd: '06:00',
        notificationContacts: '',
        disabledZoneIds: {},
      );

  @override
  Future<void> updateSettings(Map<String, dynamic> data) async {}

  @override
  Future<void> toggleZoneDetection(String zoneId, bool enabled) async {}
}
