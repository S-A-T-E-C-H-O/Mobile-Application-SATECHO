import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _sessionKey = 'auth_session_meta';
  static const _biometricEnabledKey = 'biometric_login_enabled';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveSessionMeta(Map<String, dynamic> data) =>
      _storage.write(key: _sessionKey, value: jsonEncode(data));

  Future<Map<String, dynamic>?> readSessionMeta() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveBiometricEnabled(bool enabled) =>
      _storage.write(key: _biometricEnabledKey, value: enabled.toString());

  Future<bool> readBiometricEnabled() async {
    final raw = await _storage.read(key: _biometricEnabledKey);
    return raw == 'true';
  }

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _sessionKey);
    // Biometric preference intentionally survives sign-out so the toggle
    // doesn't reset every time a farmer switches accounts on a shared device.
  }
}
