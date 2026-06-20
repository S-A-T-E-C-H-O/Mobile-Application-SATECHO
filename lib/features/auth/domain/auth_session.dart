import 'package:satecho_mobile/app/roles/user_role.dart';

class AuthSession {
  const AuthSession({
    required this.userId,
    required this.role,
    required this.accessToken,
  });

  final String userId;
  final UserRole role;
  final String accessToken;
}
