import 'package:satecho_mobile/app/roles/user_role.dart';
import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/data/auth_session_model.dart';

class AuthSessionMapper {
  const AuthSessionMapper();

  AuthSession toEntity(AuthSessionModel model) {
    final role = model.roles.any((r) => r.toUpperCase().contains('AGRONOMIST'))
        ? UserRole.agronomist
        : UserRole.farmer;

    return AuthSession(
      userId: model.id,
      role: role,
      accessToken: model.token,
    );
  }
}
