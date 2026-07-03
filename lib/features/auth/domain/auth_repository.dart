import 'package:satecho_mobile/features/auth/domain/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();
  Future<void> clearSession();
  Future<AuthSession> signIn({required String email, required String password});
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    List<String> roles,
    String? registrationNumber,
    String? specialty,
    int? yearsOfExperience,
  });
  Future<void> verifyAccount({required String token});
  Future<void> resendVerification({required String email});
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
}
