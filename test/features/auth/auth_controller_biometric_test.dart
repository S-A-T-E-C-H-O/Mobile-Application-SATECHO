import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/app/roles/user_role.dart';
import 'package:satecho_mobile/core/biometrics/biometric_auth_service.dart';
import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';
import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';

class _FakeBiometricService extends BiometricAuthService {
  _FakeBiometricService({required this.available, required List<bool> results})
      : _results = List.of(results);

  final bool available;
  final List<bool> _results;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate() async => _results.removeAt(0);
}

class _FakeAuthRepository implements AuthRepository {
  bool biometricEnabled = true;
  AuthSession? sessionToRestore;

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<void> setBiometricEnabled(bool enabled) async =>
      biometricEnabled = enabled;

  @override
  Future<AuthSession?> restoreSession() async => sessionToRestore;

  @override
  Future<void> clearSession() async {}

  @override
  Future<AuthSession> signIn(
      {required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    List<String> roles = const [],
    String? registrationNumber,
    String? specialty,
    int? yearsOfExperience,
  }) async {}

  @override
  Future<void> verifyAccount({required String token}) async {}

  @override
  Future<void> resendVerification({required String email}) async {}

  @override
  Future<void> forgotPassword({required String email}) async {}

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {}
}

void main() {
  group('AuthController biometric login', () {
    test('successful biometric auth restores the saved session', () async {
      final repo = _FakeAuthRepository()
        ..sessionToRestore = const AuthSession(
          userId: 'u1',
          role: UserRole.farmer,
          accessToken: 'token',
        );
      final controller = AuthController(
        authRepository: repo,
        biometricService:
            _FakeBiometricService(available: true, results: [true]),
      );

      final session = await controller.loginWithBiometrics();

      expect(session?.userId, 'u1');
    });

    test('failed biometric auth returns null without restoring session',
        () async {
      final repo = _FakeAuthRepository()
        ..sessionToRestore = const AuthSession(
            userId: 'u1', role: UserRole.farmer, accessToken: 't');
      final controller = AuthController(
        authRepository: repo,
        biometricService:
            _FakeBiometricService(available: true, results: [false]),
      );

      final session = await controller.loginWithBiometrics();

      expect(session, isNull);
      expect(controller.biometricFallbackToPassword, isFalse);
    });

    test('falls back to password after 3 consecutive failures', () async {
      final repo = _FakeAuthRepository();
      final controller = AuthController(
        authRepository: repo,
        biometricService: _FakeBiometricService(
            available: true, results: [false, false, false]),
      );

      await controller.loginWithBiometrics();
      await controller.loginWithBiometrics();
      await controller.loginWithBiometrics();

      expect(controller.biometricFallbackToPassword, isTrue);
      expect(controller.errorMessage, isNotNull);
    });

    test('a successful attempt resets the failure counter', () async {
      final repo = _FakeAuthRepository()
        ..sessionToRestore = const AuthSession(
            userId: 'u1', role: UserRole.farmer, accessToken: 't');
      final controller = AuthController(
        authRepository: repo,
        biometricService: _FakeBiometricService(
            available: true, results: [false, false, true]),
      );

      await controller.loginWithBiometrics();
      await controller.loginWithBiometrics();
      final session = await controller.loginWithBiometrics();

      expect(session, isNotNull);
      expect(controller.biometricFallbackToPassword, isFalse);
    });

    test('canUseBiometricLogin is false when the sensor is unavailable',
        () async {
      final repo = _FakeAuthRepository();
      final controller = AuthController(
        authRepository: repo,
        biometricService: _FakeBiometricService(available: false, results: []),
      );

      expect(await controller.canUseBiometricLogin(), isFalse);
    });

    test('canUseBiometricLogin is false when the farmer has not opted in',
        () async {
      final repo = _FakeAuthRepository()..biometricEnabled = false;
      final controller = AuthController(
        authRepository: repo,
        biometricService: _FakeBiometricService(available: true, results: []),
      );

      expect(await controller.canUseBiometricLogin(), isFalse);
    });
  });
}
