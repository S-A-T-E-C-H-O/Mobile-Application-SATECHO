import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/features/perimeter_security/infrastructure/models/security_event_model.dart';
import 'package:satecho_mobile/features/perimeter_security/infrastructure/repositories/security_event_repository_impl.dart';

SecurityEventModel _model(String classification,
    {String? locationDescription}) {
  return SecurityEventModel(
    id: 1,
    classification: classification,
    severity: 'CRITICAL',
    detectedAt: DateTime(2026, 6, 30, 12),
    locationDescription: locationDescription,
  );
}

void main() {
  group('SecurityEventRepositoryImpl classification mapping', () {
    test('PERSON classification maps to intrusion title', () {
      final event = SecurityEventRepositoryImpl.toDomainForTesting(
        _model('PERSON', locationDescription: 'Zone 3'),
      );
      expect(event.classification, 'PERSON');
      expect(event.title, 'Person detected in Zone 3');
    });

    test('ANIMAL classification maps to low-priority title', () {
      final event =
          SecurityEventRepositoryImpl.toDomainForTesting(_model('ANIMAL'));
      expect(event.classification, 'ANIMAL');
      expect(event.title, contains('Animal movement'));
    });

    test(
        'WIND classification is preserved (filtered out by the UI, not dropped here)',
        () {
      final event =
          SecurityEventRepositoryImpl.toDomainForTesting(_model('wind'));
      expect(event.classification, 'WIND');
    });

    test('lowercase classification from the API is normalized to uppercase',
        () {
      final event =
          SecurityEventRepositoryImpl.toDomainForTesting(_model('person'));
      expect(event.classification, 'PERSON');
    });
  });
}
