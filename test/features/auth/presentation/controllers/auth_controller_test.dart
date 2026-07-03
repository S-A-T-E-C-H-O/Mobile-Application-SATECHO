import 'package:flutter_test/flutter_test.dart';
import 'package:satecho_mobile/app/roles/user_role.dart';
import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';
import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('AuthController login', () {
    test('returns a session only when the repository authenticates it',
        () async {
      final controller = AuthController(
        authRepository: _FakeAuthRepository(
          session: const AuthSession(
            userId: 'user-1',
            role: UserRole.farmer,
            accessToken: 'token',
          ),
        ),
      );
      controller.updateEmail('farmer@example.com');
      controller.updatePassword('valid-password');

      final session = await controller.login();

      expect(session, isNotNull);
      expect(session!.role, UserRole.farmer);
      expect(controller.errorMessage, isNull);
    });

    test('does not return a session when the backend rejects credentials',
        () async {
      final controller = AuthController(
        authRepository:
            _FakeAuthRepository(error: Exception('Invalid email or password')),
      );
      controller.updateEmail('unknown@example.com');
      controller.updatePassword('wrong-password');

      final session = await controller.login();

      expect(session, isNull);
      expect(controller.errorMessage, 'Invalid email or password');
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.session, this.error});

  final AuthSession? session;
  final Exception? error;

  @override
  Future<void> clearSession() async {}

  @override
  Future<void> resendVerification({required String email}) async {}

  @override
  Future<void> forgotPassword({required String email}) async {}

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {}

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> setBiometricEnabled(bool enabled) async {}

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    if (error != null) throw error!;
    return session!;
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    List<String> roles = const ['ROLE_FARMER'],
    String? registrationNumber,
    String? specialty,
    int? yearsOfExperience,
  }) async {}

  @override
  Future<void> verifyAccount({required String token}) async {}
}
