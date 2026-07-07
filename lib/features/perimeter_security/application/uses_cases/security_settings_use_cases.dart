import 'package:satecho_mobile/features/perimeter_security/domain/entities/security_settings.dart';
import 'package:satecho_mobile/features/perimeter_security/domain/repositories/security_event_repository.dart';

class GetSecuritySettings {
  const GetSecuritySettings(this._repository);

  final SecurityEventRepository _repository;

  Future<SecuritySettings> call() => _repository.getSettings();
}

class UpdateSecuritySettings {
  const UpdateSecuritySettings(this._repository);

  final SecurityEventRepository _repository;

  Future<void> call(Map<String, dynamic> data) =>
      _repository.updateSettings(data);
}

class ToggleZoneDetection {
  const ToggleZoneDetection(this._repository);

  final SecurityEventRepository _repository;

  Future<void> call(String zoneId, bool enabled) =>
      _repository.toggleZoneDetection(zoneId, enabled);
}
