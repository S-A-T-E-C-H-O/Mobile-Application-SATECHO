import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/repositories/security_event_repository.dart';

class MockSecurityEventRepository implements SecurityEventRepository {
  static final _jan1 = DateTime(2025, 1, 1);

  @override
  Future<List<SecurityEvent>> getSecurityEvents() async => [
        SecurityEvent(
          id: 'sec-1',
          title: 'Movimiento detectado en Zona 1',
          zoneId: 'zone-1',
          zoneName: 'Zona 1',
          createdAt: _jan1,
          classification: 'security_pir_status',
        ),
        SecurityEvent(
          id: 'sec-2',
          title: 'Movimiento detectado en Zona 2',
          zoneId: 'zone-2',
          zoneName: 'Zona 2',
          createdAt: _jan1,
          classification: 'security_pir_status',
        ),
      ];
}
