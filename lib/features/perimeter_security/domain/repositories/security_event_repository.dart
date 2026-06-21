import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';

abstract class SecurityEventRepository {
  Future<List<SecurityEvent>> getSecurityEvents();
}
