import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/core/storage/token_storage.dart';

/// In-memory [FlutterSecureStorage] double. Read/write/delete never touch a
/// platform channel; [throwingKeys] lets a test simulate a native failure
/// (e.g. a Keystore/Keychain entry invalidated after an OS restore).
class _FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};
  final Set<String> throwingKeys = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (throwingKeys.contains(key)) {
      throw PlatformException(code: 'read_error', message: 'boom');
    }
    return values[key];
  }

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
  late TokenStorage tokenStorage;

  setUp(() {
    storage = _FakeSecureStorage();
    tokenStorage = TokenStorage(storage);
  });

  group('TokenStorage reads never throw', () {
    test('readToken returns the saved value when storage is healthy', () async {
      await tokenStorage.saveToken('abc123');
      expect(await tokenStorage.readToken(), 'abc123');
    });

    test('readToken returns null when secure storage throws PlatformException',
        () async {
      storage.throwingKeys.add('auth_token');
      expect(await tokenStorage.readToken(), isNull);
    });

    test(
        'readSessionMeta returns null when secure storage throws PlatformException',
        () async {
      storage.throwingKeys.add('auth_session_meta');
      expect(await tokenStorage.readSessionMeta(), isNull);
    });

    test('readSessionMeta returns the saved map when storage is healthy',
        () async {
      await tokenStorage.saveSessionMeta({
        'id': 'u1',
        'roles': ['ROLE_FARMER'],
      });

      final meta = await tokenStorage.readSessionMeta();

      expect(meta, {
        'id': 'u1',
        'roles': ['ROLE_FARMER'],
      });
    });

    test('readSessionMeta returns null when the stored JSON is corrupted',
        () async {
      storage.values['auth_session_meta'] = '{not valid json';
      expect(await tokenStorage.readSessionMeta(), isNull);
    });

    test('readSessionMeta returns null when the decoded JSON is not a Map',
        () async {
      storage.values['auth_session_meta'] = '[1, 2, 3]';
      expect(await tokenStorage.readSessionMeta(), isNull);
    });

    test('readBiometricEnabled returns false when secure storage throws',
        () async {
      storage.throwingKeys.add('biometric_login_enabled');
      expect(await tokenStorage.readBiometricEnabled(), isFalse);
    });
  });

  group('TokenStorage.clear', () {
    test('removes token, session meta and the biometric preference', () async {
      await tokenStorage.saveToken('abc123');
      await tokenStorage.saveSessionMeta({'id': 'u1', 'roles': <String>[]});
      await tokenStorage.saveBiometricEnabled(true);

      await tokenStorage.clear();

      expect(await tokenStorage.readToken(), isNull);
      expect(await tokenStorage.readSessionMeta(), isNull);
      expect(await tokenStorage.readBiometricEnabled(), isFalse);
    });
  });
}
