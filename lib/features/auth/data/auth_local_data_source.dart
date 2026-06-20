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

    return AuthSessionModel(
      id: meta['id'] as String,
      token: token,
      roles: (meta['roles'] as List<dynamic>).cast<String>(),
    );
  }

  Future<void> clearSession() => _storage.clear();
}
