import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/core/storage/token_storage.dart';
import 'package:satecho_mobile/features/auth/data/auth_local_data_source.dart';
import 'package:satecho_mobile/features/auth/data/auth_session_model.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}

void main() {
  late _FakeSecureStorage storage;
  late AuthLocalDataSource dataSource;

  setUp(() {
    storage = _FakeSecureStorage();
    dataSource = AuthLocalDataSource(TokenStorage(storage));
  });

  group('AuthLocalDataSource.restoreSession', () {
    test('round-trips a session saved via saveSession', () async {
      await dataSource.saveSession(
        const AuthSessionModel(id: 'u1', token: 't1', roles: ['ROLE_FARMER']),
      );

      final restored = await dataSource.restoreSession();

      expect(restored?.id, 'u1');
      expect(restored?.token, 't1');
      expect(restored?.roles, ['ROLE_FARMER']);
    });

    test('returns null when session meta is missing the id field', () async {
      storage.values['auth_token'] = 't1';
      storage.values['auth_session_meta'] = '{"roles": ["ROLE_FARMER"]}';

      expect(await dataSource.restoreSession(), isNull);
    });

    test('returns null when id has the wrong type', () async {
      storage.values['auth_token'] = 't1';
      storage.values['auth_session_meta'] = '{"id": 42, "roles": []}';

      expect(await dataSource.restoreSession(), isNull);
    });

    test('returns null when roles is not a list', () async {
      storage.values['auth_token'] = 't1';
      storage.values['auth_session_meta'] = '{"id": "u1", "roles": "oops"}';

      expect(await dataSource.restoreSession(), isNull);
    });

    test('drops non-string entries from roles instead of throwing', () async {
      storage.values['auth_token'] = 't1';
      storage.values['auth_session_meta'] =
          '{"id": "u1", "roles": ["ROLE_FARMER", 1, null]}';

      final restored = await dataSource.restoreSession();

      expect(restored?.roles, ['ROLE_FARMER']);
    });
  });
}
