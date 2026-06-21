import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_event.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/repositories/security_event_repository.dart';

class GetSecurityEvents {
  const GetSecurityEvents(this._repository);

  final SecurityEventRepository _repository;

  Future<List<SecurityEvent>> call() => _repository.getSecurityEvents();
}
