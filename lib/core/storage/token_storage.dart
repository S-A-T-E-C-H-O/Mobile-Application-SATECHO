import 'dart:convert';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper over [FlutterSecureStorage].
///
/// Policy: this class never lets a native storage failure propagate as an
/// exception. If the underlying storage is corrupted, inaccessible (e.g. a
/// Keystore/Keychain entry invalidated after an OS restore or biometric
/// re-enrollment) or holds malformed data, every read behaves as if there
/// were simply no value stored — callers (session restore, biometric login)
/// treat that as "no session" instead of crashing.
class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _sessionKey = 'auth_session_meta';
  static const _biometricEnabledKey = 'biometric_login_enabled';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _safeRead(_tokenKey);

  Future<void> saveSessionMeta(Map<String, dynamic> data) =>
      _storage.write(key: _sessionKey, value: jsonEncode(data));

  Future<Map<String, dynamic>?> readSessionMeta() async {
    final raw = await _safeRead(_sessionKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> saveBiometricEnabled(bool enabled) =>
      _storage.write(key: _biometricEnabledKey, value: enabled.toString());

  Future<bool> readBiometricEnabled() async =>
      (await _safeRead(_biometricEnabledKey)) == 'true';

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _sessionKey);
    // The biometric preference is cleared too: the app has no
    // account-picker screen before login, so on a shared device leaving it
    // enabled would offer "log in with biometrics" to the next person who
    // unlocks the device for an account that already signed out.
    await _storage.delete(key: _biometricEnabledKey);
  }

  /// Treats a native read failure the same as "key not present" instead of
  /// letting a [PlatformException] escape to callers that don't expect one.
  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      return null;
    }
  }
}
