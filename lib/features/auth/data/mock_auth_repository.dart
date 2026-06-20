import 'package:satecho_mobile/app/roles/user_role.dart';
import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<AuthSession?> restoreSession() async {
    return const AuthSession(
      userId: 'user-1',
      role: UserRole.farmer,
      accessToken: 'mock-token',
    );
  }

  @override
  Future<void> clearSession() async {}

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    return const AuthSession(
      userId: 'user-1',
      role: UserRole.farmer,
      accessToken: 'mock-token',
    );
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    List<String> roles = const ['ROLE_FARMER'],
  }) async {}

  @override
  Future<void> verifyAccount({required String token}) async {}

  @override
  Future<void> resendVerification({required String email}) async {}
}
