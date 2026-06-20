import '../../app/roles/user_role.dart';

class AuthSessionState {
  const AuthSessionState({
    required this.userId,
    required this.role,
    required this.isAuthenticated,
  });

  final String userId;
  final UserRole role;
  final bool isAuthenticated;
}
