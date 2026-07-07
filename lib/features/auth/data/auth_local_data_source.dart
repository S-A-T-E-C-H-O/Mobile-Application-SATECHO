import 'package:satecho_mobile/core/storage/token_storage.dart';
import 'package:satecho_mobile/features/auth/data/auth_session_model.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._storage);

  final TokenStorage _storage;

  Future<void> saveSession(AuthSessionModel model) async {
    await _storage.saveToken(model.token);
    await _storage.saveSessionMeta({'id': model.id, 'roles': model.roles});
  }

  Future<AuthSessionModel?> restoreSession() async {
    final token = await _storage.readToken();
    if (token == null) return null;

    final meta = await _storage.readSessionMeta();
    if (meta == null) return null;

    // TokenStorage only guarantees the outer JSON shape is a Map — the
    // fields inside it are still untrusted (e.g. a future schema change,
    // or a value written by an older app version). Falling back to "no
    // session" here keeps a shape mismatch from crashing session restore.
    final id = meta['id'];
    final roles = meta['roles'];
    if (id is! String || roles is! List) return null;

    return AuthSessionModel(
      id: id,
      token: token,
      roles: roles.whereType<String>().toList(),
    );
  }

  Future<bool> isBiometricEnabled() => _storage.readBiometricEnabled();

  Future<void> setBiometricEnabled(bool enabled) =>
      _storage.saveBiometricEnabled(enabled);
}
